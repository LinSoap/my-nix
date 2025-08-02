{ config, pkgs, ... }:

{

  home.file.".config/fastfetch" = {
    source = ./fastfetch_config;
    recursive = true;
    force = true;
  };

}
