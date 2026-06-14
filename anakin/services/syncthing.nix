{ ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  services.caddy.virtualHosts."syncthing.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy 127.0.0.1:8384 {
        header_up Host 127.0.0.1:8384
    }
  '';
}
