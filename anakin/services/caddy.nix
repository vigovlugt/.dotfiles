{ pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-mqIa0wI/VfjDblg0NnkzKllWHXZZPLwHP8xEVSwZuPE=";
    };
    environmentFile = "/etc/caddy/secrets.env";
  };
}
