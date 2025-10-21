{
  description = "Vigo's NixOS installation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    {
      nixosConfigurations = {
        cassian = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common/configuration.nix
            ./cassian/hardware-configuration.nix
            ./cassian/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.vigovlugt = inputs.nixpkgs.lib.mkMerge [
                  (import ./common/home.nix)
                  (import ./cassian/home.nix)
                ];
              };
            }
          ];
        };

        vigo-laptop-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common/configuration.nix
            ./laptop/hardware-configuration.nix
            ./laptop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.vigovlugt = inputs.nixpkgs.lib.mkMerge [
                  (import ./common/home.nix)
                  (import ./laptop/home.nix)
                ];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "vigovlugt@cassian" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./common/home.nix
            ./cassian/home.nix
          ];
        };
      };
    };
}
