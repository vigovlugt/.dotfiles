{ pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-xAw+kBA+rdhzABdogwNCo9zEtNMPG7zj5rgPpFxvpDo=";
    };
    environmentFile = "/etc/caddy/secrets.env";
  };
}
