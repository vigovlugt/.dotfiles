{ pkgs, ... }:

{
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

      ExecStartPre = "-${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup/start";
      ExecStopPost = "${pkgs.curl}/bin/curl -sS -m 10 --retry 5 https://hc-ping.com/\${HEALTHCHECKSIO_PING_KEY}/anakin-backup/\${EXIT_STATUS}";
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
      Persistent = true;
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
      OnCalendar = "0 0 1 * *";
      Persistent = true;
    };
  };
}
