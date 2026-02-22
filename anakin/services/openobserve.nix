{ pkgs, ... }:

{
  systemd.services.openobserve = {
    description = "The OpenObserve server";
    wantedBy = [ "multi-user.target" ];
    after = [
      "syslog.target"
      "network-online.target"
      "remote-fs.target"
      "nss-lookup.target"
    ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      LimitNOFILE = 65535;
      StateDirectory = "openobserve";
      Environment = [ "ZO_DATA_DIR=/var/lib/openobserve" ];
      EnvironmentFile = "/etc/openobserve/secrets.env";
      ExecStart = "${pkgs.openobserve}/bin/openobserve";
      ExecStop = "${pkgs.coreutils}/bin/kill -s QUIT $MAINPID";
      Restart = "on-failure";
    };
  };

  services.caddy.virtualHosts."openobserve.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :5080
  '';
}
