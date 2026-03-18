{ config, pkgs, ... }:

{
  home.file.".config/nvim" = {
    source = ./.;
    recursive = true;
  };
}
