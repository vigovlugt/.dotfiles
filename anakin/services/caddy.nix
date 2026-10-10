{ config, pkgs, ... }:

{
  age.secrets.caddy-env.file = ../secrets/caddy.env.age;

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-xAw+kBA+rdhzABdogwNCo9zEtNMPG7zj5rgPpFxvpDo=";
    };
    environmentFile = config.age.secrets.caddy-env.path;
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';
  };
}
