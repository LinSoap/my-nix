{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./gnome/home.nix
    inputs.zen-browser.homeModules.beta
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
    fragments # 种子下载器
    dbeaver-bin # 数据库管理工具
    discord # Discord 聊天软件
    vlc # VLC 媒体播放器
    animeko

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
    lazygit # Git 管理工具
    scrcpy # Android 设备屏幕投射工具
    postgresql # PostgreSQL 数据库
    tmux

    #开发工具
    nodejs
    # python312
    # python312Packages.pip
    uv
    asdf-vm
  ];

  # 配置 Rime 输入法
  # 通过 home.file 将 Rime 的配置文件链接到指定位置
  home.file = {
    ".local/share/fcitx5/rime/default.custom.yaml".source = ./rime/default.custom.yaml;
    ".local/share/fcitx5/rime/double_pinyin_flypy.custom.yaml".source =
      ./rime/double_pinyin_flypy.custom.yaml;
    ".local/share/fcitx5/rime/double_pinyin_flypy.schema.yaml".source =
      ./rime/double_pinyin_flypy.schema.yaml;
    ".local/share/fcitx5/rime/luna_pinyin.dict.yaml".source = ./rime/luna_pinyin.dict.yaml;
    ".local/share/fcitx5/rime/luna_pinyin.sogou.dict.yaml".source = ./rime/luna_pinyin.sogou.dict.yaml;
    ".local/share/fcitx5/rime/luna_pinyin.extended.dict.yaml".source =
      ./rime/luna_pinyin.extended.dict.yaml;
    ".local/share/fcitx5/rime/luna_pinyin_simp.custom.yaml".source =
      ./rime/luna_pinyin_simp.custom.yaml;
    ".local/share/fcitx5/rime/luna_pinyin_simp.schema.yaml".source =
      ./rime/luna_pinyin_simp.schema.yaml;
    ".local/share/fcitx5/rime/user.yaml".source = ./rime/user.yaml;
  };

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

  programs.zen-browser.enable = true;

  services.flameshot = {
    enable = true;
    # 确保启用 Wayland 支持
    package = pkgs.flameshot.override {
      enableWlrSupport = true;
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
      # --- 常用的命令行快捷键配置 (Emacs 风格) ---
      # 光标移动
      bindkey '^A' beginning-of-line       # Ctrl+A: 移动到行首
      bindkey '^E' end-of-line             # Ctrl+E: 移动到行尾
      bindkey '^F' forward-char           # Ctrl+F: 光标向前移动一个字符 
      bindkey '^B' backward-char          # Ctrl+B: 光标向后移动一个字符 
      bindkey '\M-f' forward-word          # Alt+F: 光标向前移动一个单词 (使用 Esc+f 也行)
      bindkey '\M-b' backward-word         # Alt+B: 光标向后移动一个单词 (使用 Esc+b 也行)

      # 编辑/剪切/粘贴 (Emacs 术语叫 kill/yank)
      bindkey '^K' kill-line              # Ctrl+K: 剪切从光标到行尾的内容
      bindkey '^U' backward-kill-line     # Ctrl+U: 剪切从行首到光标的内容
      bindkey '^W' backward-kill-word     # Ctrl+W: 剪切光标前的一个单词
      bindkey '^Y' yank                   # Ctrl+Y: 粘贴最近剪切的内容

      # 清屏
      bindkey '^L' clear-screen           # Ctrl+L: 清空终端屏幕，当前命令行会移到顶部
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
