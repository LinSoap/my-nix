{ ... }:
{
  programs.waybar.enable = true;
  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
  xdg.configFile."waybar/style.css".source = ./style.css;
  xdg.configFile."waybar/power_menu.sh" = {
    source = ./power_menu.sh;
    executable = true;
  };
}
