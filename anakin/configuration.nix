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

  hardware.graphics.enable = true;

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
  services.caddy.virtualHosts."mass.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8095
  '';

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

  services.couchdb = {
    enable = true;
    adminPass = "admin";
    bindAddress = "0.0.0.0";
  };
  services.caddy.virtualHosts."couchdb.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :5984
  '';

  services.postgresql = {
    enable = true;
  };

  services.tandoor-recipes = {
    enable = true;
    extraConfig = {
      ENABLE_SIGNUP = "1";
      DB_ENGINE = "django.db.backends.postgresql";
      POSTGRES_HOST = "/run/postgresql";
      POSTGRES_USER = "tandoor_recipes";
      POSTGRES_DB = "tandoor_recipes";
    };
    database.createLocally = true;
  };
  systemd.services.tandoor-recipes = {
    requires = [ "postgresql.target" ];
    after = [ "postgresql.target" ];
    serviceConfig = {
      EnvironmentFile = "/etc/tandoor-recipes/secrets.env";
    };
  };
  services.caddy.virtualHosts."tandoor.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8080
  '';

  services.immich = {
    enable = true;
    accelerationDevices = null;
    host = "0.0.0.0";
  };
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
  services.caddy.virtualHosts."immich.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :2283
  '';

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U=";
    };
    environmentFile = "/etc/caddy/secrets.env";
  };

  systemd.services.restic-backup = {
    description = "Restic Backup";

    path = [
      pkgs.restic
      pkgs.systemd
      pkgs.curl
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      EnvironmentFile = "/etc/restic/secrets.env";

      ExecStartPre = "-${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup-prune/start";
      ExecStopPost = "${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup-prune/\${EXIT_STATUS}";
    };

    script = ''
      echo "Stopping services..."
      systemctl stop opencloud couchdb postgresql immich-server tandoor-recipes actual

      trap "echo 'Restarting services...'; systemctl start opencloud couchdb postgresql immich-server tandoor-recipes actual" EXIT

      echo "Starting backup..."
      restic backup /var/lib/opencloud /var/lib/couchdb /var/lib/postgresql /var/lib/immich /var/lib/tandoor-recipes /var/lib/actual --exclude /var/lib/immich/thumbs --exclude /var/lib/immich/encoded-video
    '';
  };

  systemd.timers.restic-backup = {
    wantedBy = [ "timers.target" ];
    partOf = [ "restic-backup.service" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true; # Run immediately if the system was off at 4 AM
    };
  };

  systemd.services.restic-prune = {
    description = "Restic Prune";

    path = [
      pkgs.restic
      pkgs.curl
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      EnvironmentFile = "/etc/restic/secrets.env";

      ExecStartPre = "-${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup-prune/start";
      ExecStopPost = "${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup-prune/\${EXIT_STATUS}";
    };

    script = ''
      restic forget --prune --keep-last 7 --keep-daily 7 --keep-weekly 4 --keep-monthly 6
    '';
  };

  systemd.timers.restic-prune = {
    description = "Run restic prune weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services.restic-check = {
    description = "Restic Check";

    path = [
      pkgs.restic
      pkgs.curl
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      EnvironmentFile = "/etc/restic/secrets.env";

      ExecStartPre = "-${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup-check/start";
      ExecStopPost = "${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup-check/\${EXIT_STATUS}";
    };

    script = ''
      restic check
    '';
  };

  systemd.timers.restic-check = {
    description = "Run restic check monthly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    restic
    gdu
  ];

  services.actual.enable = true;
  services.caddy.virtualHosts."actual.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :3000
  '';

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
