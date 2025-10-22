{ config, pkgs, ... }:

{
  # 将 niri 的配置文件部署到 $HOME/.config/niri/config.kdl
  home.file.".config/niri/config.kdl" = {
    source = ./config.kdl;
    # 强制覆盖目标文件（如果已存在）
    force = true;
    # 如果你想在部署时设定权限，可以加上下面两行
    # executable = false;
    # mode = "0644";
  };
}
