{ config, pkgs, ... }:

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

    #开发工具
    asdf-vm # 版本管理工具
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
    # TODO 在这里添加你的自定义 bashrc 内容
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      ls = "eza";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
