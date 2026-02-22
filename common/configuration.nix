{ config, pkgs, ... }:

{
  imports = [
    ../modules/nixos/base.nix
    ../modules/nixos/boot.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/user.nix
    ../modules/nixos/tailscale.nix
    ../modules/nixos/avahi.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1";
  };

  services.printing.enable = true;

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."custom" = {
      "context.properties" = {
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 4096;
      };
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.libinput.enable = true;

  # Desktop-specific extra groups (merged with base user.nix groups)
  users.users.vigovlugt.extraGroups = [
    "input"
    "video"
    "docker"
    "libvirtd"
    "adbusers"
    "dialout"
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.nix-ld.enable = true;

  programs.hyprland.enable = true;

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };

  services.ollama = {
    enable = false;
  };

  programs.nh = {
    enable = true;
    flake = "/home/vigovlugt/.dotfiles";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${pkgs.hyprland}/bin/start-hyprland'";
      };
    };
  };

  services.teamviewer.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    kitty
    waybar
    mako
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    font-awesome
    inter
  ];

  systemd.services.docker.enable = false;

  system.stateVersion = "24.05";
}
