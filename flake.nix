{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux"; # 或 "aarch64-linux"，根据你的实际架构
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        # 主机1 - 台式机/主机 (使用 hardware-configuration.nix)
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            unstable = unstable;
          };
          modules = [
            ./hosts/desktop/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.linsoap = import ./home.nix;

              home-manager.extraSpecialArgs = {
                inherit inputs;
                unstable = unstable;
              };
            }
          ];
        };

        # 主机2 - 笔记本 (使用 hardware-configuration-light.nix)
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            unstable = unstable;
          };
          modules = [
            ./hosts/laptop/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.linsoap = import ./home.nix;

              # 修正：把 unstable 也传递进去
              home-manager.extraSpecialArgs = {
                inherit inputs;
                unstable = unstable;
              };
            }
          ];
        };
      };
    };
}
