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
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-9.15.9"
  ];

  services.caddy.virtualHosts."karakeep.vigovlugt.com".extraConfig = ''
    reverse_proxy :3001
  '';
}
