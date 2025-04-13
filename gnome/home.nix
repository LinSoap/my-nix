{
  config,
  lib,
  pkgs,
  ...
}:

{
  dconf.enable = true;

  home.packages = with pkgs; [
    pkgs.gnome-tweaks
    gnomeExtensions.user-themes
    gnomeExtensions.auto-move-windows
    gnomeExtensions.kimpanel
    gnomeExtensions.appindicator
    gnomeExtensions.media-controls
    gnomeExtensions.dash-to-panel
    gnomeExtensions.no-overview
    gnomeExtensions.space-bar
    gnomeExtensions.system-monitor
    gnomeExtensions.gnome-40-ui-improvements
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false; # 启用用户扩展
      enabled-extensions = with pkgs; [
        gnomeExtensions.user-themes.extensionUuid
        gnomeExtensions.auto-move-windows.extensionUuid
        gnomeExtensions.kimpanel.extensionUuid
        gnomeExtensions.appindicator.extensionUuid
        gnomeExtensions.media-controls.extensionUuid
        gnomeExtensions.dash-to-panel.extensionUuid
        gnomeExtensions.no-overview.extensionUuid
        gnomeExtensions.space-bar.extensionUuid
        gnomeExtensions.system-monitor.extensionUuid
        gnomeExtensions.gnome-40-ui-improvements.extensionUuid
      ];
    };
    # 自定义主题
    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-blue-dark";
    };

    "org/gnome/shell/extensions/gnome-ui-tune" = {
      always-show-thumbnails = true;
      hide-search = false;
      increase-thumbnails-size = "400%";
    };

    # 快捷键配置
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>e";
      command = "nautilus --new-window";
      name = "open-nautilus";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Control><Alt>t";
      command = "kgx";
      name = "open-terminal";
    };

    # appindicator配置
    "org/gnome/shell/extensions/appindicator" = {
      tray-pos = "right";
    };

    # auto-move-windows配置
    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [
        "code.desktop:2"
        "com.tencent.wechat.desktop:4"
        "chrome-cinhimbnkkaeohfgghhklpknlkffjgod-Default.desktop:4"
        "obsidian.desktop:3"
      ];
    };

    # mediacontrols配置
    "org/gnome/shell/extensions/mediacontrols" = {
      colored-player-icon = true;
      elements-order = builtins.toJSON [
        "ICON"
        "LABEL"
        "CONTROLS"
      ];
      extension-index = "uint32 0";
      extension-position = "Center";
      fixed-label-width = true;
      hide-media-notification = true;
      label-width = "uint32 120";
      labels-order = builtins.toJSON [ "TITLE" ];
      mediacontrols-show-popup-menu = builtins.toJSON [ "<Shift><Super>m" ];
      scroll-labels = true;
      show-control-icons = false;
      show-label = true;
      show-player-icon = true;
    };

    # system monitor配置
    "org/gnome/shell/extensions/system-monitor" = {
      show-download = false;
      show-swap = false;
      show-upload = false;
    };

    # space-bar配置
    "org/gnome/shell/extensions/space-bar/appearance" = {
      active-workspace-border-color = "rgb(153,193,241)";
      active-workspace-border-radius = 25;
      active-workspace-border-width = 2;
      active-workspace-font-size = 12;
      active-workspace-font-size-active = true;
      active-workspace-font-size-user = 12;
      active-workspace-padding-h = 0;
      active-workspace-padding-v = 0;
      application-styles = ''
        .space-bar {
          -natural-hpadding: 2px;
        }

        .space-bar-workspace-label.active {
          margin: 0 5px;
          background-color: rgba(255,255,255,0.3);
          color: rgba(255,255,255,1);
          border-color: rgb(153,193,241);
          font-weight: 700;
          border-radius: 25px;
          border-width: 2px;
          padding: 0px 0px;
          font-size: 12pt;
        }

        .space-bar-workspace-label.inactive {
          margin: 0 5px;
          background-color: rgba(0,0,0,0);
          color: rgba(255,255,255,1);
          border-color: rgb(255,190,111);
          font-weight: 700;
          border-radius: 25px;
          border-width: 2px;
          padding: 0px 0px;
          font-size: 12pt;
        }

        .space-bar-workspace-label.inactive.empty {
          margin: 0 5px;
          background-color: rgba(0,0,0,0);
          color: rgb(255,255,255);
          border-color: rgba(0,0,0,0);
          font-weight: 700;
          border-radius: 25px;
          border-width: 2px;
          padding: 0px 0px;
          font-size: 12pt;
        }
      '';
      empty-workspace-border-radius = 25;
      empty-workspace-border-width = 2;
      empty-workspace-font-size = 12;
      empty-workspace-padding-h = 0;
      empty-workspace-padding-v = 0;
      empty-workspace-text-color = "rgb(255,255,255)";
      inactive-workspace-border-color = "rgb(255,190,111)";
      inactive-workspace-border-radius = 25;
      inactive-workspace-border-width = 2;
      inactive-workspace-font-size = 12;
      inactive-workspace-padding-h = 0;
      inactive-workspace-padding-v = 0;
      workspace-margin = 5;
      workspaces-bar-padding = 2;
    };
    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = false;
      indicator-style = "workspaces-bar";
      show-empty-workspaces = true;
      toggle-overview = true;
    };
    "org/gnome/shell/extensions/space-bar/state" = {
      version = 32;
    };

    # dash-to-panel配置
    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover-animation-extent = builtins.toJSON {
        RIPPLE = 4;
        PLANK = 4;
        SIMPLE = 1;
      };
      dot-position = "BOTTOM";
      hotkeys-overlay-combo = "TEMPORARILY";
      panel-anchors = builtins.toJSON {
        "LHC-0000000000000" = "MIDDLE";
      };
      panel-element-positions = builtins.toJSON {
        "LHC-0000000000000" = [
          {
            element = "showAppsButton";
            visible = false;
            position = "stackedTL";
          }
          {
            element = "activitiesButton";
            visible = false;
            position = "stackedTL";
          }
          {
            element = "leftBox";
            visible = true;
            position = "stackedTL";
          }
          {
            element = "taskbar";
            visible = false;
            position = "stackedTL";
          }
          {
            element = "centerBox";
            visible = true;
            position = "centerMonitor";
          }
          {
            element = "rightBox";
            visible = true;
            position = "stackedBR";
          }
          {
            element = "dateMenu";
            visible = true;
            position = "stackedBR";
          }
          {
            element = "systemMenu";
            visible = true;
            position = "stackedBR";
          }
          {
            element = "desktopButton";
            visible = false;
            position = "stackedBR";
          }
        ];
      };
      panel-lengths = builtins.toJSON { };
      panel-positions = builtins.toJSON {
        "LHC-0000000000000" = "TOP";
      };
      panel-sizes = builtins.toJSON {
        "LHC-0000000000000" = 32;
      };
      prefs-opened = false;
      primary-monitor = "LHC-0000000000000";
      scroll-icon-action = "NOTHING";
      scroll-panel-action = "NOTHING";
      stockgs-keep-top-panel = false;
      trans-panel-opacity = 0.0;
      trans-use-custom-opacity = true;
      tray-size = 16;
      window-preview-title-position = "TOP";
    };
  };
}
