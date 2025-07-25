{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix # 笔记本硬件配置
    ../common.nix # 通用配置
  ];

  # 笔记本特定配置
  networking.hostName = "nixos-laptop";

  # 笔记本特定的电源管理和节能配置
  # 禁用 GNOME 的 power-profiles-daemon，因为它与 TLP 冲突
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # 触摸板支持
  services.libinput.enable = true;
  services.libinput.touchpad = {
    tapping = true;
    naturalScrolling = true;
    disableWhileTyping = true;
  };

  # 亮度控制
  programs.light.enable = true;

  # 笔记本可能需要的其他配置
  # 例如：无线网络优化、蓝牙等
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
