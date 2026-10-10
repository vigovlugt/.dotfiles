{ config, ... }:

{
  # cert and key are copied into place by root; the GUI password is read by syncthing-init as the syncthing user
  age.secrets.syncthing-cert.file = ../secrets/syncthing-cert.pem.age;
  age.secrets.syncthing-key.file = ../secrets/syncthing-key.pem.age;
  age.secrets.syncthing-gui-password = {
    file = ../secrets/syncthing-gui-password.age;
    owner = "syncthing";
    group = "syncthing";
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    cert = config.age.secrets.syncthing-cert.path;
    key = config.age.secrets.syncthing-key.path;
    guiPasswordFile = config.age.secrets.syncthing-gui-password.path;
    settings = {
      gui.user = "admin";
      devices.cassian.id = "HXCJWJG-TLPNRUU-MM2GON3-BSKTE4U-H2JDU7H-QY5LFZZ-36CQIV3-HIMEYAU";
      devices.r2d2.id = "TQ3WM4O-26Z7FVN-GF2M6TJ-Y54DFIU-IRHLOUH-SFU3N4W-3GGKB6W-GNAIXQL";
      folders.notes = {
        path = "/var/lib/syncthing/notes";
        devices = [
          "cassian"
          "r2d2"
        ];
      };
    };
  };

  services.caddy.virtualHosts."syncthing.vigovlugt.com".extraConfig = ''
    reverse_proxy 127.0.0.1:8384 {
        header_up Host 127.0.0.1:8384
    }
  '';
}
