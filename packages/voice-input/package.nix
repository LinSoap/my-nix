{ lib
, stdenv
, cmake
, ninja
, pkg-config
, fcitx5
, python3
, python3Full
, ffmpeg
, libnotify
}:
stdenv.mkDerivation {
  pname = "voice-input";
  version = "0.1.0";

  src = lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      let
        base = baseNameOf path;
      in
        !(builtins.elem base [
          "build"
          ".git"
          "__pycache__"
          "result"
        ]);
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fcitx5
  ];

  propagatedBuildInputs = [
    python3
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  postInstall = ''
    substituteInPlace "$out/bin/run_mock_service.sh" \
      --replace-fail 'exec "$SCRIPT_DIR/mock_asr_service.py"' 'export PATH=${lib.makeBinPath [ ffmpeg libnotify python3 ]}:$PATH
exec "$SCRIPT_DIR/mock_asr_service.py"'
    substituteInPlace "$out/bin/run_status_overlay.sh" \
      --replace-fail 'exec "$SCRIPT_DIR/status_overlay.py"' 'export PATH=${lib.makeBinPath [ python3 ]}:$PATH
exec ${lib.getExe python3Full} "$SCRIPT_DIR/status_overlay.py"'
  '';

  meta = with lib; {
    description = "Fcitx5 voice input plugin with a Python NanoASR backend";
    platforms = platforms.linux;
  };
}
