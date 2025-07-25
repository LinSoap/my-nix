{
  inputs,
  config,
  pkgs,
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # 网络配置
  networking.enableIPv6 = false;
  networking.proxy.default = "http://127.0.0.1:20122";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

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

  # 输入法配置
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];
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
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs.gnome; [ ];

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
      pkgs.librime
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
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

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
    vim
    tree
    gnumake
    gcc
    libglibutil
    glib
    firefoxpwa
    wineWowPackages.waylandFull
    winetricks
    xdg-desktop-portal-gnome
  ];

  # 环境变量
  environment.sessionVariables = rec {
    ENABLE_DEPRECATED_SPECIAL_OUTBOUNDS = "true";
    ENABLE_DEPRECATED_TUN_ADDRESS_X = "true";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    QT_QPA_PLATFORM = "wayland";
  };

  # 防火墙
  networking.firewall.enable = false;

  # 系统版本
  system.stateVersion = "25.05";
}
