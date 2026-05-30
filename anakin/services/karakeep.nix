{ ... }:

{
  services.karakeep = {
    enable = true;
    extraEnvironment = {
      NEXTAUTH_URL = "https://karakeep.vigovlugt.com";
      PORT = "3001";
      DISABLE_NEW_RELEASE_CHECK = "true";
    };
  };

  services.caddy.virtualHosts."karakeep.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :3001
  '';
}
