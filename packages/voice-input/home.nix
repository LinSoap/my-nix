{ config, pkgs, lib, ... }:

let
  voice-input-package = pkgs.callPackage ./package.nix { };
  voice-input-trigger = pkgs.writeShellApplication {
    name = "voice-input";
    runtimeInputs = with pkgs; [
      systemd
    ];
    text = ''
      set -euo pipefail

      busctl --user call org.fcitx.Fcitx5 /voiceinput org.fcitx.Fcitx.VoiceInput1 Trigger >/dev/null
    '';
  };
in
{
  home.packages = [
    voice-input-trigger
  ];

  systemd.user.services.voice-input-mock-asr = {
    Unit = {
      Description = "ASR backend for fcitx5 voice input";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${voice-input-package}/bin/run_mock_service.sh";
      Environment = [
        "VOICE_INPUT_API_URL=https://nanoasr.aimzai.com/offline/recognize"
        "VOICE_INPUT_ENABLE_NOTIFY=1"
      ];
      EnvironmentFile = [
        "-%h/.config/voice-input/env"
      ];
      Restart = "always";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
