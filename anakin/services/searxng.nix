{ ... }:

{
  services.searx = {
    enable = true;
    environmentFile = "/var/lib/searx/secrets.env";
    settings = {
      server = {
        base_url = "https://searxng.vigovlugt.com/";
        bind_address = "127.0.0.1";
        port = 8083;
        secret_key = "$SEARXNG_SECRET_KEY";
      };
      search.formats = [
        "html"
        "json"
      ];
    };
  };

  services.caddy.virtualHosts."searxng.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8083
  '';

}
