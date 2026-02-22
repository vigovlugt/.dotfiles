{ pkgs, ... }:

{
  systemd.services.opencode-web = {
    description = "OpenCode Web Interface";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "vigovlugt";
      Group = "users";
      WorkingDirectory = "/home/vigovlugt";
      ExecStart = "${pkgs.opencode}/bin/opencode web";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  services.caddy.virtualHosts."opencode.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :4096
  '';
}
