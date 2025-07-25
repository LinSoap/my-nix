{ config, pkgs, ... }:

{
  # 直接将当前目录下的 fcitx5 配置链接到默认位置
  home.file.".local/share/fcitx5/rime" = {
    source = ./fcitx5/rime;
    recursive = true;
    force = true; # 强制覆盖现有文件
  };
  home.file.".local/share/fcitx5/themes" = {
    source = ./fcitx5/themes;
    recursive = true;
    force = true; # 强制覆盖现有文件
  };
}
