#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import mimetypes
import os
import shutil
import signal
import socket
import subprocess
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path

APP_NAME = "voice-input"
API_URL = os.environ.get(
    "VOICE_INPUT_API_URL",
    "https://nanoasr.aimzai.com/offline/recognize",
)
SOCKET_PATH = Path(
    os.environ.get(
        "VOICE_INPUT_SOCKET",
        os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), APP_NAME, "mock-asr.sock"),
    )
)
LOG_PATH = Path(
    os.environ.get(
        "VOICE_INPUT_LOG_PATH",
        os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), APP_NAME, "mock-asr.log"),
    )
)
NOTIFY_ID_PATH = Path(
    os.environ.get(
        "VOICE_INPUT_NOTIFY_ID_PATH",
        os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), APP_NAME, "notify-id"),
    )
)
STATUS_PATH = Path(
    os.environ.get(
        "VOICE_INPUT_STATUS_PATH",
        os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), APP_NAME, "status.json"),
    )
)
DEFAULT_SOURCE = os.environ.get("VOICE_INPUT_SOURCE", "default")
DEFAULT_BATCH_SIZE_S = os.environ.get("VOICE_INPUT_BATCH_SIZE_S", "300")
DEFAULT_BATCH_SIZE_THRESHOLD_S = os.environ.get("VOICE_INPUT_BATCH_SIZE_THRESHOLD_S", "60")
ENABLE_NOTIFY = os.environ.get("VOICE_INPUT_ENABLE_NOTIFY", "0").lower() in ("1", "true", "yes", "on")


class VoiceInputError(RuntimeError):
    pass


@dataclass
class RecorderState:
    pid: int
    output_path: str
    started_at: float


def runtime_dir() -> Path:
    return Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / APP_NAME


STATE_DIR = runtime_dir()
STATE_PATH = STATE_DIR / "state.json"
RECORDING_PATH = STATE_DIR / "recording.wav"


def log(message: str) -> None:
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    with LOG_PATH.open("a", encoding="utf-8") as fh:
        fh.write(f"{message}\n")


def notify(title: str, body: str) -> None:
    if not ENABLE_NOTIFY:
        return
    notify_send = shutil.which("notify-send")
    if not notify_send:
        return
    subprocess.run([notify_send, title, body], check=False)  # noqa: S603


def read_notify_id() -> str | None:
    try:
        value = NOTIFY_ID_PATH.read_text(encoding="utf-8").strip()
    except OSError:
        return None
    return value or None


def write_notify_id(notify_id: str) -> None:
    NOTIFY_ID_PATH.parent.mkdir(parents=True, exist_ok=True)
    NOTIFY_ID_PATH.write_text(notify_id, encoding="utf-8")


def clear_notify_id() -> None:
    if NOTIFY_ID_PATH.exists():
        NOTIFY_ID_PATH.unlink()


def notify_status(title: str, body: str, *, expire_ms: int = 0) -> None:
    if not ENABLE_NOTIFY:
        return
    notify_send = shutil.which("notify-send")
    if not notify_send:
        return

    cmd = [notify_send, "-p", "-t", str(expire_ms)]
    replace_id = read_notify_id()
    if replace_id:
        cmd.extend(["-r", replace_id])
    cmd.extend([title, body])

    result = subprocess.run(  # noqa: S603
        cmd,
        check=False,
        capture_output=True,
        text=True,
    )
    notify_id = result.stdout.strip()
    if result.returncode == 0 and notify_id:
        write_notify_id(notify_id)

    if expire_ms > 0:
        clear_notify_id()


def ensure_socket_dir() -> None:
    SOCKET_PATH.parent.mkdir(parents=True, exist_ok=True)
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    if SOCKET_PATH.exists():
        SOCKET_PATH.unlink()


def process_alive(pid: int) -> bool:
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    return True


def read_state() -> RecorderState | None:
    if not STATE_PATH.exists():
        return None
    try:
        payload = json.loads(STATE_PATH.read_text(encoding="utf-8"))
        state = RecorderState(
            pid=int(payload["pid"]),
            output_path=str(payload["output_path"]),
            started_at=float(payload["started_at"]),
        )
    except (OSError, ValueError, KeyError, json.JSONDecodeError):
        clear_state()
        return None

    if not process_alive(state.pid):
        clear_state()
        return None
    return state


def write_state(state: RecorderState) -> None:
    payload = {
        "pid": state.pid,
        "output_path": state.output_path,
        "started_at": state.started_at,
    }
    STATE_PATH.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")


def clear_state() -> None:
    if STATE_PATH.exists():
        STATE_PATH.unlink()


def set_status(
    state: str,
    message: str,
    *,
    detail: str = "",
    timeout_ms: int | None = None,
) -> None:
    STATUS_PATH.parent.mkdir(parents=True, exist_ok=True)
    payload: dict[str, object] = {
        "visible": state != "idle",
        "state": state,
        "message": message,
        "detail": detail,
        "updated_at": time.time(),
    }
    if timeout_ms is not None:
        payload["timeout_ms"] = timeout_ms
    STATUS_PATH.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")


def clear_status() -> None:
    set_status("idle", "", detail="", timeout_ms=0)
    clear_notify_id()


def stop_process(pid: int) -> None:
    try:
        os.killpg(pid, signal.SIGINT)
    except ProcessLookupError:
        return

    deadline = time.time() + 5
    while time.time() < deadline:
        if not process_alive(pid):
            return
        time.sleep(0.1)

    try:
        os.killpg(pid, signal.SIGTERM)
    except ProcessLookupError:
        return


def optimize_text(text: str, enabled: bool) -> str:
    text = text.strip()
    if not enabled or not text:
        return text
    if text.endswith(("。", "！", "？")):
        return text
    return text + "。"


def start_recording() -> dict[str, object]:
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        raise VoiceInputError("missing_ffmpeg")

    if RECORDING_PATH.exists():
        RECORDING_PATH.unlink()

    cmd = [
        ffmpeg,
        "-hide_banner",
        "-loglevel",
        "error",
        "-y",
        "-f",
        "pulse",
        "-i",
        DEFAULT_SOURCE,
        "-ac",
        "1",
        "-ar",
        "16000",
        "-c:a",
        "pcm_s16le",
        str(RECORDING_PATH),
    ]
    process = subprocess.Popen(  # noqa: S603
        cmd,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )
    time.sleep(0.2)
    if process.poll() is not None:
        raise VoiceInputError("ffmpeg_start_failed")

    state = RecorderState(
        pid=process.pid,
        output_path=str(RECORDING_PATH),
        started_at=time.time(),
    )
    write_state(state)
    set_status("recording", "正在录音", detail="再次按下快捷键结束")
    notify_status("Voice Input", "正在录音，再按一次快捷键结束。", expire_ms=0)
    log(f"voice-input: recording started pid={process.pid} path={RECORDING_PATH}")
    return {"ok": True, "status": "recording_started"}


def transcribe_file(path: Path, optimize: bool) -> dict[str, object]:
    response_payload = post_multipart(
        url=API_URL,
        fields={
            "batch_size_s": DEFAULT_BATCH_SIZE_S,
            "batch_size_threshold_s": DEFAULT_BATCH_SIZE_THRESHOLD_S,
        },
        file_field="file",
        file_path=path,
    )

    try:
        payload = json.loads(response_payload)
    except json.JSONDecodeError:
        log(f"voice-input: nanoasr bad json payload={response_payload}")
        raise VoiceInputError("nanoasr_bad_json")

    if not payload.get("success"):
        log(f"voice-input: nanoasr failed payload={json.dumps(payload, ensure_ascii=False)}")
        raise VoiceInputError("nanoasr_failed")

    results = payload.get("results")
    if not isinstance(results, list) or not results:
        log(f"voice-input: nanoasr missing results payload={json.dumps(payload, ensure_ascii=False)}")
        raise VoiceInputError("nanoasr_missing_results")

    text = "".join(
        item.get("text", "") or item.get("text_tn", "")
        for item in results
        if isinstance(item, dict)
    )
    if not text and isinstance(results, list):
        text = "".join(
            item.get("text_tn", "")
            for item in results
            if isinstance(item, dict)
        )
    text = optimize_text(text, optimize)
    if not text:
        log(f"voice-input: nanoasr empty text payload={json.dumps(payload, ensure_ascii=False)}")
        raise VoiceInputError("nanoasr_empty_text")

    log(f"voice-input: nanoasr success text={text}")
    return {
        "ok": True,
        "status": "recognized",
        "text": text,
        "provider": "nanoasr",
    }


def post_multipart(
    *,
    url: str,
    fields: dict[str, str],
    file_field: str,
    file_path: Path,
) -> str:
    boundary = f"----voiceinput-{time.time_ns()}"
    body = bytearray()
    for key, value in fields.items():
        body.extend(f"--{boundary}\r\n".encode("utf-8"))
        body.extend(
            f'Content-Disposition: form-data; name="{key}"\r\n\r\n'.encode("utf-8")
        )
        body.extend(str(value).encode("utf-8"))
        body.extend(b"\r\n")

    mime_type, _ = mimetypes.guess_type(file_path.name)
    if not mime_type:
        mime_type = "application/octet-stream"

    body.extend(f"--{boundary}\r\n".encode("utf-8"))
    body.extend(
        (
            f'Content-Disposition: form-data; name="{file_field}"; '
            f'filename="{file_path.name}"\r\n'
        ).encode("utf-8")
    )
    body.extend(f"Content-Type: {mime_type}\r\n\r\n".encode("utf-8"))
    body.extend(file_path.read_bytes())
    body.extend(b"\r\n")
    body.extend(f"--{boundary}--\r\n".encode("utf-8"))

    req = urllib.request.Request(
        url,
        data=bytes(body),
        headers={"Content-Type": f"multipart/form-data; boundary={boundary}"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=180) as resp:  # noqa: S310
            return resp.read().decode("utf-8")
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        log(f"voice-input: nanoasr http error status={exc.code} detail={detail}")
        raise VoiceInputError("nanoasr_http_error") from exc
    except urllib.error.URLError as exc:
        log(f"voice-input: nanoasr network error {exc}")
        raise VoiceInputError("nanoasr_network_error") from exc


def stop_and_recognize(optimize: bool) -> dict[str, object]:
    state = read_state()
    if state is None:
        return start_recording()

    stop_process(state.pid)
    clear_state()
    set_status("processing", "正在识别", detail="请稍候")
    notify_status("Voice Input", "录音已结束，正在识别。", expire_ms=0)
    log(f"voice-input: recording stopped pid={state.pid}")

    path = Path(state.output_path)
    if not path.exists():
        raise VoiceInputError("recording_missing")

    response = transcribe_file(path, optimize)
    text = str(response.get("text", "")).strip()
    if text:
        set_status("success", "已输入", detail=text, timeout_ms=1200)
        notify_status("Voice Input", f"识别完成: {text}", expire_ms=1800)
    else:
        set_status("error", "未识别到内容", detail="", timeout_ms=1600)
        notify_status("Voice Input", "未识别到内容。", expire_ms=1800)
    return response


def handle_toggle(payload: dict[str, object]) -> dict[str, object]:
    optimize = bool(payload.get("optimize", False))
    return stop_and_recognize(optimize)


def handle_client(conn: socket.socket) -> None:
    reader = conn.makefile("r", encoding="utf-8")
    writer = conn.makefile("w", encoding="utf-8")
    line = reader.readline()
    if not line:
        return

    try:
        payload = json.loads(line)
    except json.JSONDecodeError:
        log("voice-input: invalid json")
        writer.write(json.dumps({"ok": False, "status": "error", "error": "invalid_json"}) + "\n")
        writer.flush()
        return

    if payload.get("action") != "recognize":
        log(f"voice-input: unsupported action {payload.get('action')}")
        writer.write(json.dumps({"ok": False, "status": "error", "error": "unsupported_action"}) + "\n")
        writer.flush()
        return

    try:
        response = handle_toggle(payload)
    except VoiceInputError as exc:
        error = str(exc)
        log(f"voice-input: error {error}")
        set_status("error", "语音输入失败", detail=error, timeout_ms=2200)
        notify_status("Voice Input Error", error, expire_ms=2200)
        response = {"ok": False, "status": "error", "error": error}

    writer.write(json.dumps(response, ensure_ascii=False) + "\n")
    writer.flush()


class Server:
    def __init__(self) -> None:
        self.server: socket.socket | None = None

    def start(self) -> None:
        ensure_socket_dir()
        self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server.bind(str(SOCKET_PATH))
        self.server.listen(16)
        log(f"voice-input: listening on {SOCKET_PATH}")
        print(f"voice input service listening on {SOCKET_PATH}", flush=True)

    def close(self) -> None:
        if self.server is not None:
            self.server.close()
            self.server = None
        if SOCKET_PATH.exists():
            SOCKET_PATH.unlink()


def cli() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--transcribe-file", type=Path)
    args = parser.parse_args()

    if args.transcribe_file:
        response = transcribe_file(args.transcribe_file, optimize=True)
        print(json.dumps(response, ensure_ascii=False))
        return 0

    server = Server()
    clear_status()

    def shutdown(signum, frame):
        clear_status()
        server.close()
        sys.exit(0)

    signal.signal(signal.SIGINT, shutdown)
    signal.signal(signal.SIGTERM, shutdown)

    server.start()
    while True:
        conn, _ = server.server.accept()
        with conn:
            handle_client(conn)


if __name__ == "__main__":
    raise SystemExit(cli())
