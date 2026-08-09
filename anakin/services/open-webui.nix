{ ... }:

{
  services.open-webui = {
    enable = true;
    port = 8082;
    environment.HOME = "/var/lib/open-webui";
  };

  services.caddy.virtualHosts."openwebui.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8082
  '';
}
