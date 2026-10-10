{ ... }:

{
  services.immich = {
    enable = true;
    accelerationDevices = null;
    host = "0.0.0.0";
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.caddy.virtualHosts."immich.vigovlugt.com".extraConfig = ''
    reverse_proxy :2283
  '';
}
