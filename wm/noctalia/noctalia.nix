{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];
  # install package
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage "${inputs.noctalia}/nix/package.nix" {
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
    })
  ];

  # Enable noctalia-shell service
  services.noctalia-shell = {
    enable = true;
    package = pkgs.callPackage "${inputs.noctalia}/nix/package.nix" {
      quickshell = inputs.quickshell.packages.${pkgs.system}.default;
    };
  };
}
