{ config, pkgs, ... }:

{
  # 直接将当前目录下的 fcitx5 配置链接到默认位置
  home.file.".local/share/fcitx5" = {
    source = ./fcitx5;
    recursive = true;
  };
  
  # 也可以设置环境变量指向自定义位置（可选）
  # home.sessionVariables = {
  #   FCITX_DATA_HOME = "${config.home.homeDirectory}/my-nix/fcitx5";
  # };
}
