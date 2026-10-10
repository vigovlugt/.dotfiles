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
    reverse_proxy :9200
  '';
}
