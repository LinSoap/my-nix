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
    marble-shell-theme
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
    gnomeExtensions.color-picker
    gnomeExtensions.pano
    gnomeExtensions.blur-my-shell
    gnomeExtensions.paperwm
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false; # 启用用户扩展
      enabled-extensions = with pkgs; [
        gnomeExtensions.user-themes.extensionUuid
        # gnomeExtensions.auto-move-windows.extensionUuid
        gnomeExtensions.kimpanel.extensionUuid
        gnomeExtensions.appindicator.extensionUuid
        gnomeExtensions.media-controls.extensionUuid
        gnomeExtensions.dash-to-panel.extensionUuid
        gnomeExtensions.no-overview.extensionUuid
        # gnomeExtensions.space-bar.extensionUuid
        gnomeExtensions.system-monitor.extensionUuid
        gnomeExtensions.gnome-40-ui-improvements.extensionUuid
        gnomeExtensions.color-picker.extensionUuid
        gnomeExtensions.pano.extensionUuid
        gnomeExtensions.blur-my-shell.extensionUuid
        gnomeExtensions.paperwm.extensionUuid
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

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      workspaces-only-on-primary = false;
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      cursor-theme = "Afterglow-Recolored-Original-Blue";
      font-hinting = "full";
    };

    # 桌面背景配置
    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file://${config.home.homeDirectory}/my-nix/assets/wallpaper.jpg";
      picture-uri-dark = "file://${config.home.homeDirectory}/my-nix/assets/wallpaper.jpg";
      primary-color = "#3a4ba0";
      secondary-color = "#2f302f";
    };

    #----------快捷键配置----------

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      play = [ "<Shift><Super>space" ];
      next = [ "<Shift><Super>n" ];
      previous = [ "<Shift><Super>p" ];
    };
    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ ];
      open-new-window-application-1 = [ ];
      open-new-window-application-2 = [ ];
      open-new-window-application-3 = [ ];
      open-new-window-application-4 = [ ];
      open-new-window-application-5 = [ ];
      open-new-window-application-6 = [ ];
      open-new-window-application-7 = [ ];
      open-new-window-application-8 = [ ];
      open-new-window-application-9 = [ ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      show-screenshot-ui = [ "<Control>Delete" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ ];
      begin-move = [ ];
      begin-resize = [ ];
      cycle-group = [ ];
      cycle-group-backward = [ ];
      cycle-panels = [ ];
      cycle-panels-backward = [ ];
      cycle-windows = [ ];
      cycle-windows-backward = [ ];
      maximize = [ ];
      minimize = [ ];
      move-to-monitor-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-workspace-1 = [ ];
      move-to-workspace-down = [ ];
      move-to-workspace-last = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      panel-run-dialog = [ ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-panels = [ ];
      switch-panels-backward = [ ];
      switch-to-workspace-1 = [ ];
      switch-to-workspace-last = [ ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
      toggle-maximized = [ ];
      unmaximize = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus" = {
      binding = "<Super>e";
      command = "nautilus --new-window";
      name = "open-nautilus";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      binding = "<Control><Alt>t";
      command = "kitty";
      name = "open-terminal";
    };

    #----------快捷键配置结束----------
    # appindicator配置
    "org/gnome/shell/extensions/appindicator" = {
      tray-pos = "right";
    };

    # auto-move-windows配置
    # "org/gnome/shell/extensions/auto-move-windows" = {
    #   application-list = [
    #     "code.desktop:2"
    #     "com.tencent.wechat.desktop:4"
    #     "obsidian.desktop:3"
    #   ];
    # };

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

    #开启缩放功能
    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
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
    "org/gnome/shell/extensions/space-bar" = {
      enable-activate-workspace-shortcuts = true;
    };

    "org/gnome/desktop/applications/terminal" = {
      exec = "kitty";
      exec-arg = "";
    };

    # dash-to-panel配置
    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover-animation-extent = builtins.toJSON {
        RIPPLE = 4;
        PLANK = 4;
        SIMPLE = 1;
      };
      appicon-margin = 8;
      appicon-padding = 4;
      dot-position = "BOTTOM";
      extension-version = 68;
      global-border-radius = 5;
      highlight-appicon-hover = true;
      hotkeys-overlay-combo = "NEVER";
      intellihide = false;
      isolate-monitors = false;
      leftbox-padding = -1;
      leftbox-size = 0;
      multi-monitors = false;
      panel-anchors = builtins.toJSON {
        "LHC-0000000000000" = "MIDDLE";
        "SDC-0x00000000" = "MIDDLE";
        "SGT-demoset-1" = "MIDDLE";
        "SAM-0x304a4b36" = "MIDDLE";
      };
      panel-element-positions = builtins.toJSON {
        "LHC-0000000000000" = [
          {
            element = "showAppsButton";
            position = "stackedTL";
            visible = false;
          }
          {
            element = "activitiesButton";
            position = "stackedTL";
            visible = false;
          }
          {
            element = "leftBox";
            position = "stackedTL";
            visible = true;
          }
          {
            element = "taskbar";
            position = "stackedTL";
            visible = false;
          }
          {
            element = "centerBox";
            position = "centerMonitor";
            visible = true;
          }
          {
            element = "rightBox";
            position = "stackedBR";
            visible = true;
          }
          {
            element = "dateMenu";
            position = "stackedBR";
            visible = true;
          }
          {
            element = "systemMenu";
            position = "stackedBR";
            visible = true;
          }
          {
            element = "desktopButton";
            position = "stackedBR";
            visible = false;
          }
        ];
        "SDC-0x00000000" = [
          {
            element = "showAppsButton";
            position = "stackedTL";
            visible = false;
          }
          {
            element = "activitiesButton";
            position = "stackedTL";
            visible = false;
          }
          {
            element = "leftBox";
            position = "stackedTL";
            visible = true;
          }
          {
            element = "dateMenu";
            position = "stackedTL";
            visible = true;
          }
          {
            element = "taskbar";
            position = "stackedTL";
            visible = false;
          }
          {
            element = "centerBox";
            position = "centerMonitor";
            visible = true;
          }
          {
            element = "rightBox";
            position = "stackedBR";
            visible = true;
          }
          {
            element = "systemMenu";
            position = "stackedBR";
            visible = true;
          }
          {
            element = "desktopButton";
            position = "stackedBR";
            visible = false;
          }
        ];
      };
      panel-element-positions-monitors-sync = true;
      panel-lengths = builtins.toJSON { };
      panel-positions = builtins.toJSON {
        "LHC-0000000000000" = "TOP";
        "SDC-0x00000000" = "TOP";
        "SGT-demoset-1" = "TOP";
        "SAM-0x304a4b36" = "TOP";
      };
      panel-side-margins = 2;
      panel-side-padding = 0;
      panel-sizes = builtins.toJSON {
        "LHC-0000000000000" = 30;
        "SDC-0x00000000" = 30;
        "SGT-demoset-1" = 32;
        "SAM-0x304a4b36" = 30;
      };
      panel-top-bottom-margins = 2;
      panel-top-bottom-padding = 0;
      prefs-opened = false;
      primary-monitor = "LHC-0000000000000";
      scroll-icon-action = "NOTHING";
      scroll-panel-action = "NOTHING";
      status-icon-padding = -1;
      stockgs-keep-dash = false;
      stockgs-keep-top-panel = false;
      stockgs-panelbtn-click-only = false;
      trans-bg-color = "#555555";
      trans-panel-opacity = 0.0;
      trans-use-custom-bg = true;
      trans-use-custom-gradient = false;
      trans-use-custom-opacity = false;
      trans-use-dynamic-opacity = false;
      tray-padding = -1;
      tray-size = 16;
      window-preview-title-position = "TOP";
    };

    # blur-my-shell配置
    "org/gnome/shell/extensions/blur-my-shell" = {
      debug = false;
      "settings-version" = 2;
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      blur = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      blur = false;
      pipeline = "pipeline_default";
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      pipeline = "pipeline_default_rounded";
      "style-dash-to-dock" = 0;
      "unblur-in-overview" = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-panel" = {
      "blur-original-panel" = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      blur = true;
      pipeline = "pipeline_default";
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      pipeline = "pipeline_default";
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
      "override-background" = false;
      pipeline = "pipeline_default";
      "unblur-in-overview" = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      blur = false;
      pipeline = "pipeline_default";
    };
    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      blur = false;
    };

    # PaperWM configuration
    "org/gnome/shell/extensions/paperwm" = {
      default-focus-mode = 0;
      disable-scratch-in-overview = true;
      edge-preview-enable = true;
      edge-preview-timeout-enable = false;
      horizontal-margin = 4;
      last-used-display-server = "Wayland";
      only-scratch-in-overview = false;
      open-window-position = 0;
      overview-ensure-viewport-animation = 1;
      restore-attach-modal-dialogs = "true";
      restore-edge-tiling = "true";
      restore-keybinds = ''{"cancel-input-capture":{"bind":"[\"<Super><Shift>Escape\"]","schema_id":"org.gnome.mutter.keybindings"},"restore-shortcuts":{"bind":"[\"<Super>Escape\"]","schema_id":"org.gnome.mutter.wayland.keybindings"},"switch-to-workspace-last":{"bind":"[\"<Super>End\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-panels":{"bind":"[\"<Control><Alt>Tab\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-group-backward":{"bind":"[\"<Shift><Super>Above_Tab\",\"<Shift><Alt>Above_Tab\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"unmaximize":{"bind":"[\"<Super>Down\",\"<Alt>F5\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-left":{"bind":"[\"<Super><Shift>Left\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-down":{"bind":"[\"<Super><Shift>Down\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-to-workspace-left":{"bind":"[\"<Super>Page_Up\",\"<Super><Alt>Left\",\"<Control><Alt>Left\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-group":{"bind":"[\"<Super>Above_Tab\",\"<Alt>Above_Tab\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-panels-backward":{"bind":"[\"<Shift><Control><Alt>Tab\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-up":{"bind":"[\"<Control><Shift><Alt>Up\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-to-workspace-right":{"bind":"[\"<Super>Page_Down\",\"<Super><Alt>Right\",\"<Control><Alt>Right\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-down":{"bind":"[\"<Control><Shift><Alt>Down\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-applications":{"bind":"[\"<Super>Tab\",\"<Alt>Tab\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"maximize":{"bind":"[\"<Super>Up\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-right":{"bind":"[\"<Super><Shift>Right\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-applications-backward":{"bind":"[\"<Shift><Super>Tab\",\"<Shift><Alt>Tab\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-monitor-up":{"bind":"[\"<Super><Shift>Up\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"shift-overview-up":{"bind":"[\"<Super><Alt>Up\"]","schema_id":"org.gnome.shell.keybindings"},"shift-overview-down":{"bind":"[\"<Super><Alt>Down\"]","schema_id":"org.gnome.shell.keybindings"},"toggle-message-tray":{"bind":"[\"<Super>v\",\"<Super>m\"]","schema_id":"org.gnome.shell.keybindings"},"rotate-video-lock-static":{"bind":"[\"<Super>o\",\"XF86RotationLockToggle\"]","schema_id":"org.gnome.settings-daemon.plugins.media-keys"},"move-to-workspace-left":{"bind":"[\"<Super><Shift>Page_Up\",\"<Super><Shift><Alt>Left\",\"<Control><Shift><Alt>Left\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"move-to-workspace-right":{"bind":"[\"<Super><Shift>Page_Down\",\"<Super><Shift><Alt>Right\",\"<Control><Shift><Alt>Right\"]","schema_id":"org.gnome.desktop.wm.keybindings"},"switch-to-workspace-1":{"bind":"[\"<Super>Home\"]","schema_id":"org.gnome.desktop.wm.keybindings"}}'';
      restore-workspaces-only-on-primary = "false";
      selection-border-radius-top = 0;
      selection-border-size = 0;
      show-window-position-bar = false;
      show-workspace-indicator = false;
      use-default-background = true;
      vertical-margin = 4;
      vertical-margin-bottom = 4;
      window-gap = 4;
      winprops = [ ];
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      close-window = [ "<Super>q" ];
      drift-left = [ ];
      drift-right = [ ];
      live-alt-tab = [ ];
      live-alt-tab-backward = [ ];
      move-down = [ ];
      move-left = [ "<Shift><Super>a" ];
      move-right = [ "<Shift><Super>d" ];
      move-up = [ ];
      new-window = [ ];
      switch-down = [ ];
      switch-fifth = [ "<Super>5" ];
      switch-first = [ "<Super>1" ];
      switch-focus-mode = [ ];
      switch-fourth = [ "<Super>4" ];
      switch-last = [ ];
      switch-left = [ ];
      switch-next = [ ];
      switch-next-loop = [ "<Super>x" ];
      switch-open-window-position = [ ];
      switch-previous = [ ];
      switch-previous-loop = [ "<Super>z" ];
      switch-right = [ ];
      switch-second = [ "<Super>2" ];
      switch-seventh = [ "<Super>7" ];
      switch-sixth = [ "<Super>6" ];
      switch-third = [ "<Super>3" ];
      switch-up = [ ];
    };
  };
}
