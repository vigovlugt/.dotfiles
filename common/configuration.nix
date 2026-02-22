{ pkgs, ... }:

{
  imports = [
    ../modules/nixos/base.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/user.nix
    ../modules/nixos/tailscale.nix
    ../modules/nixos/avahi.nix
    ../modules/nixos/nvidia.nix
    ../modules/nixos/pipewire.nix
    ../modules/nixos/bluetooth.nix
    ../modules/nixos/printing.nix
    ../modules/nixos/steam.nix
    ../modules/nixos/hyprland.nix
    ../modules/nixos/kde.nix
    ../modules/nixos/docker.nix
    ../modules/nixos/libvirtd.nix
    ../modules/nixos/teamviewer.nix
    ../modules/nixos/nix-ld.nix
    ../modules/nixos/fonts.nix
    ../modules/nixos/swap.nix
    ../modules/nixos/libinput.nix
  ];

  # Desktop-specific extra groups (merged with base user.nix groups)
  users.users.vigovlugt.extraGroups = [
    "input"
    "video"
    "docker"
    "libvirtd"
    "adbusers"
    "dialout"
  ];

  environment.systemPackages = with pkgs; [
    wget
    git
    kitty
    waybar
    mako
  ];

  system.stateVersion = "24.05";
}
