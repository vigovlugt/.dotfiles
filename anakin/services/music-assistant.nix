{ ... }:

{
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
}
