{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./gnome/home.nix
  ];

  home.username = "linsoap";
  home.homeDirectory = "/home/linsoap";

  fonts.fontconfig.enable = true;

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs; [
    # GUI 软件
    obsidian # 笔记软件
    wechat-uos # 微信客户端
    google-chrome # 谷歌浏览器
    vscode # Visual Studio Code 编辑器
    gui-for-singbox # Sing-box 的图形界面
    krita # 数字绘画软件
    krita-plugin-gmic
    dconf-editor
    wpsoffice-cn # WPS 办公软件
    feishu # 飞书
    # follow # RSS 阅读器
    chromium

    waydroid-helper
    android-tools

    afterglow-cursors-recolored # 鼠标指针主题
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    noto-fonts-emoji # 🤓️

    # 实用工具
    zip # 压缩工具
    nixfmt-rfc-style # Nix 格式化工具
    fastfetch # 系统信息展示工具
    yq-go # YAML 处理工具 https://github.com/mikefarah/yq
    eza # 现代化的 ls 替代工具
    fzf # 命令行模糊搜索工具
    glow # 终端中的 Markdown 预览工具
    btop # htop/nmon 的替代工具
    iotop # IO 监控工具
    iftop # 网络流量监控工具
    lsof # 查看打开文件的工具
    joshuto # 终端文件管理器
    lua # Lua 语言
    z-lua # zsh 的 cd 命令替代工具
    wl-clipboard # 终端剪贴板工具
    cacert # CA 证书
    lazydocker # Docker 管理工具

    #开发工具
    nodejs_23
    python312
    python312Packages.pip
    uv
    asdf-vm
  ];

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "LinSoap";
    userEmail = "linsoap1024@outlook.com";
  };

  programs.starship = {
    enable = true;
    # 自定义配置
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      export SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
    '';
    initExtra = ''
      . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
      . "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash"
    '';

    shellAliases = {
      ls = "eza";
      jo = "joshuto";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # enableBashCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza";
    };
    history.size = 10000;
    initContent = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      eval "$(${pkgs.z-lua}/bin/z --init zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "z"
        "vi-mode"
        "copypath"
      ];
    };
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
