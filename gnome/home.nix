{ config, pkgs, ...}:

{
    dconf.enable = true;

    home.packages = with pkgs; [
	      pkgs.gnome-tweaks

	      gnomeExtensions.media-controls
        gnomeExtensions.appindicator
    ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false; # 启用用户扩展
      enabled-extensions = [
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.media-controls.extensionUuid
        # 其他扩展的 UUID
      ];
    };

    #appindicator配置
    "org/gnome/shell/extensions/appindicator" = {
      "tray-pos" = "right";

    };
    #mediacontrols配置
    "org/gnome/shell/extensions/mediacontrols" = {
        "colored-player-icon"=true;
        "elements-order"="['ICON', 'LABEL', 'CONTROLS']";
        "extension-index"="uint32 0";
        "extension-position"="Center";
        "fixed-label-width"=true;
        "hide-media-notification"=true;
        "label-width"="uint32 120";
        "labels-order"="['TITLE']";
        "mediacontrols-show-popup-menu"="['<Shift><Super>m']";
        "scroll-labels"=true;
        "show-control-icons"=true;
        "show-control-icons-next"=true;
        "show-control-icons-previous"=true;
        "show-control-icons-seek-backward"=false;
        "show-control-icons-seek-forward"=false;
        "show-label"=true;
        "show-player-icon"=true;
    };
  };
}
