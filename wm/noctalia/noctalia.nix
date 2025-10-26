{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];
  # install package
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.system}.default
  ];

  # Enable noctalia-shell service
  services.noctalia-shell = {
    enable = true;
  };
}
