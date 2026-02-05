{
  description = "Vigo's NixOS installations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    galactus = {
      url = "git+ssh://git@github.com/vigovlugt/galactus.git"; # nix flake update galactus
      inputs.nixpkgs.follows = "nixpkgs";
    };
    porta-potty = {
      url = "git+ssh://git@github.com/vigovlugt/porta-potty.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      galactus,
      porta-potty,
      ...
    }:
    {
      nixosConfigurations = {
        cassian = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./common/configuration.nix
            ./cassian/hardware-configuration.nix
            ./cassian/configuration.nix
            home-manager.nixosModules.home-manager
            galactus.nixosModules.default
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
            galactus.nixosModules.default
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

        anakin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./anakin/configuration.nix
            ./anakin/hardware-configuration.nix
            porta-potty.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.vigovlugt = inputs.nixpkgs.lib.mkMerge [
                  (import ./anakin/home.nix)
                ];
              };
            }
          ];
        };
      };
    };
}
