{ ... }:

{
  services.actual.enable = true;

  services.caddy.virtualHosts."actual.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :3000
  '';
}
