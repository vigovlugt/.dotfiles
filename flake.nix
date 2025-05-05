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
        vigo-desktop-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common/configuration.nix
            ./desktop/hardware-configuration.nix
            ./desktop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vigovlugt = inputs.nixpkgs.lib.mkMerge [
                (import ./common/home.nix)
                (import ./desktop/home.nix)
              ];
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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vigovlugt = inputs.nixpkgs.lib.mkMerge [
                (import ./common/home.nix)
                (import ./laptop/home.nix)
              ];
            }
          ];
        };
      };
    };
}
