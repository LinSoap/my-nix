#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import time
import tkinter as tk
from pathlib import Path


APP_NAME = "voice-input"
STATUS_PATH = Path(
    os.environ.get(
        "VOICE_INPUT_STATUS_PATH",
        os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), APP_NAME, "status.json"),
    )
)
POLL_MS = 120


class StatusOverlay:
    def __init__(self) -> None:
        self.root = tk.Tk()
        self.root.withdraw()
        self.root.overrideredirect(True)
        self.root.attributes("-topmost", True)
        self.root.configure(bg="#101218")

        self.frame = tk.Frame(
            self.root,
            bg="#101218",
            highlightthickness=1,
            highlightbackground="#2A2F3A",
            bd=0,
            padx=14,
            pady=10,
        )
        self.frame.pack()

        self.indicator = tk.Canvas(
            self.frame,
            width=12,
            height=12,
            bg="#101218",
            bd=0,
            highlightthickness=0,
        )
        self.indicator.grid(row=0, column=0, rowspan=2, padx=(0, 10), sticky="n")
        self.dot = self.indicator.create_oval(1, 1, 11, 11, fill="#8B93A1", outline="")

        self.message_var = tk.StringVar()
        self.detail_var = tk.StringVar()

        self.message = tk.Label(
            self.frame,
            textvariable=self.message_var,
            bg="#101218",
            fg="#F5F7FB",
            anchor="w",
            font=("Sans", 13, "bold"),
        )
        self.message.grid(row=0, column=1, sticky="w")

        self.detail = tk.Label(
            self.frame,
            textvariable=self.detail_var,
            bg="#101218",
            fg="#BFC6D2",
            anchor="w",
            justify="left",
            font=("Sans", 10),
        )
        self.detail.grid(row=1, column=1, sticky="w")

        self.last_payload: dict[str, object] | None = None
        self.root.after(POLL_MS, self.poll)

    def read_payload(self) -> dict[str, object]:
        if not STATUS_PATH.exists():
            return {"visible": False, "state": "idle", "message": "", "detail": ""}
        try:
            return json.loads(STATUS_PATH.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            return {"visible": False, "state": "idle", "message": "", "detail": ""}

    def place_window(self) -> None:
        self.root.update_idletasks()
        width = self.root.winfo_width()
        height = self.root.winfo_height()
        screen_width = self.root.winfo_screenwidth()
        x = max(16, screen_width - width - 20)
        y = 20
        self.root.geometry(f"{width}x{height}+{x}+{y}")

    def set_color(self, state: str) -> None:
        color = {
            "recording": "#F2464D",
            "processing": "#F5B736",
            "success": "#46D67D",
            "error": "#FF6F6F",
        }.get(state, "#8B93A1")
        self.indicator.itemconfigure(self.dot, fill=color)

    def poll(self) -> None:
        payload = self.read_payload()
        visible = bool(payload.get("visible", False))
        updated_at = float(payload.get("updated_at", 0.0) or 0.0)
        timeout_ms = int(payload.get("timeout_ms", 0) or 0)
        if visible and timeout_ms > 0 and time.time() > updated_at + timeout_ms / 1000:
            visible = False

        if not visible:
            self.root.withdraw()
            self.last_payload = payload
            self.root.after(POLL_MS, self.poll)
            return

        if payload != self.last_payload or self.root.state() == "withdrawn":
            state = str(payload.get("state", "idle"))
            self.message_var.set(str(payload.get("message", "")))
            detail = str(payload.get("detail", ""))
            self.detail_var.set(detail[:72])
            self.set_color(state)
            self.root.deiconify()
            self.place_window()
            self.last_payload = payload

        self.root.after(POLL_MS, self.poll)

    def run(self) -> int:
        self.root.mainloop()
        return 0


def main() -> int:
    return StatusOverlay().run()


if __name__ == "__main__":
    raise SystemExit(main())
