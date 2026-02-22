{ ... }:

{
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
}
