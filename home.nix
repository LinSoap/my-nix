{
  config,
  pkgs,
  inputs,
  unstable,
  master,
  lib,
  ...
}:

{
  imports = [
    # ./gnome/home.nix
    ./wm/noctalia/home.nix
    # ./wofi/home.nix
    # ./waybar/home.nix
    ./wlogout/home.nix
    ./fcitx5/home.nix
    ./cli/kitty/home.nix
    ./cli/fastfetch/home.nix
    ./cli/nvim/home.nix
    ./niri/home.nix
    ./packages/voice-input/home.nix
    ./node-global/home.nix # 使用 node2nix 管理的全局 Node.js 包
  ];

  home.username = "linsoap";
  home.homeDirectory = "/home/linsoap";

  # 设置默认终端为 kitty
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "terminal.desktop" = "kitty.desktop";
      "text/html" = "google-chrome-beta.desktop";
      "x-scheme-handler/http" = "google-chrome-beta.desktop";
      "x-scheme-handler/https" = "google-chrome-beta.desktop";
      "x-scheme-handler/about" = "google-chrome-beta.desktop";
    };
  };

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
    unstable.wechat # 微信客户端
    master.vscode # Visual Studio Code 编辑器
    # clash-verge-rev # Clash Verge 客户端
    #    gui-for-singbox # Sing-box 的图形界面
    krita # 数字绘画软件
    krita-plugin-gmic # GMIC 插件
    dconf-editor # dconf 配置编辑器
    wpsoffice-cn # WPS 办公软件
    feishu # 飞书
    qq # QQ 聊天软件
    fragments # 种子下载器
    dbeaver-bin # 数据库管理工具
    discord # Discord 聊天软件
    vlc # VLC 媒体播放器
    animeko # 动漫播放器
    kitty # Kitty 终端
    proton-pass # Proton Pass
    insomnia # Insomnia API 客户端
    appimage-run # AppImage 运行工具
    unstable.claude-code # AI 代码助手
    unstable.claude-code-router # AI 代码助手 路由器
    koodo-reader # 电子书阅读器
    # chromium # Chromium 浏览器
    inputs.browser-previews.packages.${pkgs.system}.google-chrome-beta # Google Chrome Beta 浏览器 (来自 browser-previews flake)
    unstable.google-chrome # Google Chrome 稳定版 (来自 nixpkgs)

    localsend # LocalSend 局域网文件传输工具
    element-desktop # Element 聊天软件
    grim # 截图工具
    slurp # 截图选区工具

    waydroid-helper # Waydroid 助手
    android-tools # Android 工具

    afterglow-cursors-recolored # 鼠标指针主题
    nerd-fonts.fira-code # Fira Code 字体
    nerd-fonts.droid-sans-mono # Droid Sans Mono 字体
    noto-fonts-emoji # 🤓️

    # 实用工具
    openssl # SSL 工具包
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
    zoxide # 常用目录快速跳转工具
    wl-clipboard # 终端剪贴板工具
    cacert # CA 证书
    lazydocker # Docker 管理工具
    lazygit # Git 管理工具
    lazysql # SQL 管理工具
    unstable.lazyssh # SSH 管理工具
    scrcpy # Android 设备屏幕投射工具
    postgresql # PostgreSQL 数据库
    jq # JSON 处理工具
    tmux # 终端复用工具
    neovim # Neovim 编辑器 (LazyVim)
    mpv # MPV 媒体播放器
    libnotify # 消息通知库
    pandoc # 文档转换工具
    bubblewrap # 沙箱工具
    ripgrep # 快速搜索工具
    socat # 多功能网络工具
    wget # 文件下载工具
    bat # cat 命令的增强版
    ripgrep # 快速文本搜索工具
    rclone # 云存储同步工具

    #开发工具
    sqlite # 轻量级数据库
    devbox # Devbox 开发环境管理工具
    nodejs_22 # Node.js 22 版本
    nodePackages_latest.pnpm # 更新到最新版本的 pnpm
    kubectl # Kubernetes 命令行工k具
    cri-tools # Kubernetes CRI 工具
    rustc # Rust 编译器
    cmake # 跨平台构建工具
    unstable.ultralytics # Ultralytis 目标检测工具
    kompose # Docker Compose 工具
    vesktop # Custom Discord

    ffmpeg # 多媒体处理工具
    portaudio # 音频处理库
    android-studio # Android Studio IDE
    uv # UV Python 工具
    bun # Bun JavaScript 运行时
    cargo # Rust 包管理器
    nodePackages_latest.vercel # Vercel CLI
    prisma # Prisma ORM 工具
    prisma-engines
    wrangler # Cloudflare Workers CLI
    biome # Biome 代码工具
    kdePackages.qttools # Qt 工具集
    playwright-driver.browsers # Playwright 浏览器驱动
  ];

  home.sessionVariables = {
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    BROWSER = "google-chrome-beta";
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "1";
  };

  # 为 agent-browser 创建符号链接，匹配其期望的目录结构
  home.activation.linkPlaywrightBrowsers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PLAYWRIGHT_CACHE="$HOME/.cache/ms-playwright"
    mkdir -p "$PLAYWRIGHT_CACHE"

    NIX_BROWSERS="${pkgs.playwright-driver.browsers}"

    # chromium headless shell - 需要特殊的目录结构
    HEADLESS_DIR="$PLAYWRIGHT_CACHE/chromium_headless_shell-1208"
    rm -rf "$HEADLESS_DIR"
    mkdir -p "$HEADLESS_DIR/chrome-headless-shell-linux64"
    ln -sf "$NIX_BROWSERS/chromium_headless_shell-1169/chrome-linux/headless_shell" \
           "$HEADLESS_DIR/chrome-headless-shell-linux64/chrome-headless-shell"

    # chromium regular
    CHROMIUM_DIR="$PLAYWRIGHT_CACHE/chromium-1208"
    rm -rf "$CHROMIUM_DIR"
    mkdir -p "$CHROMIUM_DIR/chrome-linux"
    ln -sf "$NIX_BROWSERS/chromium-1169/chrome-linux/chrome" \
           "$CHROMIUM_DIR/chrome-linux/chrome"
  '';

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

  services.kdeconnect.enable = true;

  programs.atuin = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # enableBashCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = false;
    shellAliases = {
      ls = "eza";
      vim = "nvim";
      icat = "kitty +kitten icat";
      ssh = "kitty +kitten ssh";
      jo = "joshuto";
      cat = "bat";
    };
    history.size = 10000;
    initContent = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.bun/bin"
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

      # Rust 源码路径
      export RUST_SRC_PATH="${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

      # Fix for gnome-keyring
      if [ -z "$SSH_AUTH_SOCK" ]; then
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh
      fi

      # Prisma 环境变量
      export PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
      export PRISMA_QUERY_ENGINE_BINARY="${pkgs.prisma-engines}/bin/query-engine"
      export PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"

      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
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

      # 延迟加载 fast-syntax-highlighting 以优化启动速度
      autoload -Uz add-zsh-hook
      _load_fast_syntax_highlighting() {
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        add-zsh-hook -d precmd _load_fast_syntax_highlighting
        unset -f _load_fast_syntax_highlighting
      }
      add-zsh-hook precmd _load_fast_syntax_highlighting
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "vi-mode"
        "copypath"
        "copyfile"
      ];
    };
  };

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

}
