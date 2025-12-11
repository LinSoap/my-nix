{ pkgs, inputs, ... }:
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  gtk = {
    enable = true;
    theme = {
      name = "TokyoNight-Dark";
      package = pkgs.tokyo-night-gtk;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme.name = "qtct";
  # };

  home.packages = with pkgs; [
    #桌面环境相关
    tokyo-night-gtk
    pavucontrol # PulseAudio 音量控制器
    swaybg # Sway 壁纸管理器
    adwaita-icon-theme # Adwaita 图标主题
    papirus-icon-theme # Papirus 图标主题
    bibata-cursors # Bibata 鼠标指针主题
    brightnessctl # 屏幕亮度调节工具

    libappindicator-gtk3
  ];

  programs.noctalia-shell = {
    enable = true;
    package = pkgs.callPackage "${inputs.noctalia}/nix/package.nix" {
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
    };
    settings = {
      settingsVersion = 16;
      setupCompleted = false;
      bar = {
        position = "top";
        backgroundOpacity = 0.85;
        monitors = [ ];
        density = "default";
        showCapsule = true;
        floating = true;
        marginVertical = 0.1;
        marginHorizontal = 0.25;
        widgets = {
          left = [
            {
              id = "Workspace";
              characterCount = 4;
            }

            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "NotificationHistory";
            }
            {
              id = "Clock";
              formatHorizontal = "MM/dd HH:mm ddd";
              formatVertical = "MM/HH mm - dd ";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "SystemMonitor";
              showCpuTemp = false;
              showNetworkStats = true;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "Battery";
              displayMode = "alwaysShow";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
          ];
        };
      };
      general = {
        avatarImage = "~/my-nix/assets/avatar.png";
        dimDesktop = true;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        compactLockScreen = false;
        lockOnSuspend = true;
        language = "zh-CN";
      };
      location = {
        name = "Huzhou";
        weatherEnabled = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
      };
      screenRecorder = {
        directory = "";
        frameRate = 60;
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        audioSource = "default_output";
        videoSource = "portal";
      };
      wallpaper = {
        enabled = false;
        directory = "";
        enableMultiMonitorDirectories = false;
        setWallpaperOnAllMonitors = true;
        defaultWallpaper = "";
        fillMode = "crop";
        fillColor = "#000000";
        randomEnabled = false;
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
        transitionEdgeSmoothness = 0.05;
        monitors = [ ];
      };
      appLauncher = {
        enableClipboardHistory = false;
        position = "center";
        backgroundOpacity = 1;
        pinnedExecs = [ ];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "xterm -e";
      };
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      dock = {
        enabled = false;
        displayMode = "always_visible";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        monitors = [ ];
        pinnedApps = [ ];
        colorizeIcons = false;
      };
      network = {
        wifiEnabled = true;
      };
      notifications = {
        doNotDisturb = false;
        monitors = [ ];
        location = "top_right";
        overlayLayer = true;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
      };
      osd = {
        enabled = true;
        location = "top_right";
        monitors = [ ];
        autoHideMs = 2000;
        overlayLayer = true;
      };
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 60;
        visualizerType = "linear";
        mprisBlacklist = [ ];
        preferredPlayer = "";
      };
      ui = {
        fontDefault = "Roboto";
        fontFixed = "DejaVu Sans Mono";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelsOverlayLayer = true;
      };
      brightness = {
        brightnessStep = 5;
      };
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Tokyo Night";
        darkMode = true;
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };
      templates = {
        gtk = false;
        qt = false;
        kcolorscheme = false;
        kitty = false;
        ghostty = false;
        foot = false;
        fuzzel = false;
        discord = false;
        discord_vesktop = false;
        discord_webcord = false;
        discord_armcord = false;
        discord_equibop = false;
        discord_lightcord = false;
        discord_dorion = false;
        pywalfox = false;
        enableUserTemplates = false;
      };
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
      };
      battery = {
        chargingMode = 0;
      };
    };
  };
}
