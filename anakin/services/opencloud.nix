{ ... }:

{
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
}
