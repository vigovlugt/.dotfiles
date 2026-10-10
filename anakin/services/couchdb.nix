{ ... }:

{
  services.couchdb = {
    enable = true;
    adminPass = "admin";
    bindAddress = "0.0.0.0";
  };

  services.caddy.virtualHosts."couchdb.vigovlugt.com".extraConfig = ''
    reverse_proxy :5984
  '';
}
