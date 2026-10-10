{ config, ... }:

{
  age.secrets.searxng-env.file = ../secrets/searxng.env.age;

  services.searx = {
    enable = true;
    environmentFile = config.age.secrets.searxng-env.path;
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
    reverse_proxy :8083
  '';

}
