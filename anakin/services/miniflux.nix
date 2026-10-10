{ ... }:

{
  services.miniflux = {
    enable = true;
    adminCredentialsFile = "/etc/miniflux/secrets.env";
    config = {
      BASE_URL = "https://miniflux.vigovlugt.com";
      LISTEN_ADDR = "localhost:8081";
    };
  };

  services.caddy.virtualHosts."miniflux.vigovlugt.com".extraConfig = ''
    reverse_proxy :8081
  '';
}
