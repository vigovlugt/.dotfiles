{ ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    cert = "/etc/syncthing/cert.pem";
    key = "/etc/syncthing/key.pem";
    guiPasswordFile = "/etc/syncthing/gui-password";
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
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy 127.0.0.1:8384 {
        header_up Host 127.0.0.1:8384
    }
  '';
}
