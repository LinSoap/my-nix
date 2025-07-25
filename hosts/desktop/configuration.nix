{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix # 台式机硬件配置
    ../common.nix # 通用配置
  ];

  # 台式机特定配置
  networking.hostName = "nixos-desktop";

  # 台式机可能需要的特定配置
  # 例如：更强的显卡、更多的存储等

  # 如果台式机有特定的硬件需求，在这里添加
  # 例如：
  # hardware.nvidia.enable = true;  # 如果有 NVIDIA 显卡
  # services.xserver.videoDrivers = [ "nvidia" ];
}
