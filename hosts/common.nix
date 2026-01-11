{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  # 通用配置，适用于所有主机

  # 启动加载器配置
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    theme = pkgs.catppuccin-grub;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelModules = [ "tun" ];

  # 虚拟化配置
  virtualisation.waydroid.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
    };
    daemon.settings = {
      data-root = "/home/linsoap/Docker";
    };
  };

  # Nix 配置
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # 网络配置
  networking.enableIPv6 = true;
  networking.proxy.default = "http://127.0.0.1:7897";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" ];

  # 配置 fcitx5 输入法
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5
      fcitx5-rime
      fcitx5-configtool
      fcitx5-chinese-addons
      rime-data
      librime
    ];
  };

  # 时区和语言
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # 字体配置
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      sarasa-gothic # 更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
    ];
  };

  # 桌面环境配置
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = false;
  programs.niri.enable = true;

  # 键盘配置
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # 打印服务
  services.printing.enable = true;

  # 音频配置
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  programs.dconf.enable = true;

  programs.xwayland.enable = true;
  programs.gpu-screen-recorder.enable = true;
  # XDG Desktop Portal 配置
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.niri = {
      # 尝试将屏幕共享和截屏分配给 GNOME 后端
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      default = [
        "gtk"
      ];
    };
  };

  #ssh 服务配置
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = true; # enable password login
    };
    openFirewall = true;
  };

  services.tailscale.enable = true;

  # 用户配置
  users.users.linsoap = {
    isNormalUser = true;
    description = "LinSoap";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      pkgs.git
    ];
  };
  users.extraGroups.docker.members = [ "linsoap" ];

  # 登录配置
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "linsoap";

  # 系统服务调整
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # 程序配置
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox;
  #   nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  # };

  programs.zsh.enable = true;
  users.users.linsoap.shell = pkgs.zsh;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      uv
      asdf-vm
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # 系统包
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nautilus # 文件管理器
    vim # 终端文本编辑器
    unzip # 解压缩工具
    tree # 目录树查看工具
    gnumake # GNU Make 工具
    gcc # GNU 编译器集合
    libglibutil # GLib 工具库
    glib # GLib 库
    firefoxpwa # Firefox PWA 支持
    wineWowPackages.waylandFull # 带有 Wayland 支持的 Wine
    winetricks # Wine 辅助脚本
    gpu-screen-recorder-gtk # GPU加速屏幕录制工具
    xwayland-satellite # XWayland 卫星程序
    xdg-desktop-portal-gnome # XDG 桌面门户 GNOME 后端
    xdg-desktop-portal-gtk # XDG 桌面门户
    libsecret # 用于密码管理
    tailscale # Tailscale VPN 客户端
  ];

  # 环境变量
  environment.sessionVariables = {
    ENABLE_DEPRECATED_SPECIAL_OUTBOUNDS = "true";
    ENABLE_DEPRECATED_TUN_ADDRESS_X = "true";
    QT_QPA_PLATFORM = "wayland;xcb"; # 允许Qt回退到XCB
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    TERMINAL = "kitty"; # 设置默认终端
    # QS_ICON_THEME = "Adwaita,Papirus";
  };

  # 强制覆盖输入法相关的环境变量
  environment.variables = {
    GTK_IM_MODULE = lib.mkForce "";
  };

  # 防火墙
  networking.firewall.enable = false;

  # 蓝牙支持
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # 系统版本
  system.stateVersion = "25.11";
}
