{ ... }:

{
  services.open-webui = {
    enable = true;
    port = 8082;
    environment = {
      HOME = "/var/lib/open-webui";
      ENABLE_WEB_SEARCH = "true";
      WEB_SEARCH_ENGINE = "searxng";
      SEARXNG_QUERY_URL = "http://127.0.0.1:8083/search?q=<query>";
    };
  };

  services.caddy.virtualHosts."openwebui.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8082
  '';
}
