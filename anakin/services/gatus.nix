{ config, lib, ... }:

{
  age.secrets.gatus-env.file = ../secrets/gatus.env.age;

  services.gatus = {
    enable = true;
    environmentFile = config.age.secrets.gatus-env.path;
    settings = {
      web = {
        address = "127.0.0.1";
        port = 3002;
      };
      storage = {
        type = "sqlite";
        path = "/var/lib/gatus/data.db";
      };
      alerting.email = {
        from = "vigovlugt@gmail.com";
        username = "vigovlugt@gmail.com";
        password = "\${GMAIL_APP_PASSWORD}"; # interpolated by Gatus from environmentFile
        host = "smtp.gmail.com";
        port = 587;
        to = "vigovlugt@gmail.com";
        default-alert = {
          failure-threshold = 3; # 3 failed checks in a row = ~3 minutes down
          success-threshold = 2;
          send-on-resolved = true;
        };
      };
      # One check per Caddy host, so new services are monitored automatically
      endpoints = map (host: {
        name = lib.removeSuffix ".vigovlugt.com" host;
        url = "https://${host}";
        interval = "1m";
        conditions = [
          "[STATUS] < 500"
          "[CERTIFICATE_EXPIRATION] > 168h"
        ];
        alerts = [ { type = "email"; } ];
      }) (builtins.attrNames config.services.caddy.virtualHosts);
    };
  };

  services.caddy.virtualHosts."gatus.vigovlugt.com".extraConfig = ''
    reverse_proxy :3002
  '';
}
