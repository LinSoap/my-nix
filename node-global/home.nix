{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./default.nix { })
  ];
}
