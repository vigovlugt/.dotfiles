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

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.tailscale.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    allowInterfaces = [ "eno1" ];
  };

  services.music-assistant = {
    enable = true;
    providers = [
      "chromecast"
      "spotify"
    ];
  };
  systemd.services.music-assistant.serviceConfig.Restart = "on-failure";
  systemd.services.music-assistant.serviceConfig.RestartSec = 5;
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "google_translate" # TTS
      "met" # weather
      "isal" # better compression
      "music_assistant"
      "samsungtv"
      "cast"
      "spotify"
    ];
    config = {
      default_config = { };
      http = {
        base_url = "https://hass.vigovlugt.com";
        use_x_forwarded_for = true;
        trusted_proxies = "127.0.0.1";
      };
    };
  };
  services.caddy.virtualHosts."hass.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8123
  '';

  services.opencloud = {
    enable = true;
    environment = {
      PROXY_TLS = "false";
      ADMIN_PASSWORD = "admin";
    };
    url = "https://opencloud.vigovlugt.com";
  };
  services.caddy.virtualHosts."opencloud.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :9200
  '';

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-4qUWhrv3/8BtNCi48kk4ZvbMckh/cGRL7k+MFvXKbTw=";
    };
    environmentFile = "/run/secrets/caddy.env";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  services.openssh.enable = true;
  users.users.vigovlugt.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMoSFdoJdNFgDvjxrlGZW+oi8mOZA++9g4wI3t8oTPJ cassian"
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMoSFdoJdNFgDvjxrlGZW+oi8mOZA++9g4wI3t8oTPJ cassian"
  ];

  networking.firewall.enable = false;

  system.stateVersion = "25.05";
}
