{ config, ... }:

{
  age.secrets.miniflux-env.file = ../secrets/miniflux.env.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux-env.path;
    config = {
      BASE_URL = "https://miniflux.vigovlugt.com";
      LISTEN_ADDR = "localhost:8081";
    };
  };

  services.caddy.virtualHosts."miniflux.vigovlugt.com".extraConfig = ''
    reverse_proxy :8081
  '';
}
