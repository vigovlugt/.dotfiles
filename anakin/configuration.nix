{ pkgs, ... }:

{
  imports = [
    ../modules/nixos/base.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/user.nix
    ../modules/nixos/tailscale.nix
    ../modules/nixos/avahi.nix
    ../modules/nixos/openssh.nix
    ./services/caddy.nix
    ./services/home-assistant.nix
    ./services/music-assistant.nix
    ./services/opencloud.nix
    ./services/couchdb.nix
    ./services/postgresql.nix
    ./services/tandoor.nix
    ./services/immich.nix
    ./services/actual.nix
    ./services/openobserve.nix
    ./services/opencode-web.nix
    ./services/restic.nix
    ./services/galactus.nix
    ./services/porta-potty.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "anakin";

  services.getty.autologinUser = "vigovlugt";

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    restic
    gdu
    opencode
  ];

  users.users.vigovlugt.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMoSFdoJdNFgDvjxrlGZW+oi8mOZA++9g4wI3t8oTPJ cassian"
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMoSFdoJdNFgDvjxrlGZW+oi8mOZA++9g4wI3t8oTPJ cassian"
  ];

  system.stateVersion = "25.05";
}
