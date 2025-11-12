{ config, pkgs, ... }:
{
  boot.loader = {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "anakin";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.vigovlugt = {
    isNormalUser = true;
    description = "Vigo Vlugt";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.getty.autologinUser = "vigovlugt";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  services.openssh.enable = true;
  users.users.vigovlugt.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMoSFdoJdNFgDvjxrlGZW+oi8mOZA++9g4wI3t8oTPJ cassian"
  ];

  networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
