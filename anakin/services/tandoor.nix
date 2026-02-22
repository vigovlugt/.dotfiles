{ ... }:

{
  services.tandoor-recipes = {
    enable = true;
    extraConfig = {
      ENABLE_SIGNUP = "1";
      DB_ENGINE = "django.db.backends.postgresql";
      POSTGRES_HOST = "/run/postgresql";
      POSTGRES_USER = "tandoor_recipes";
      POSTGRES_DB = "tandoor_recipes";
      MEDIA_ROOT = "/var/lib/tandoor-recipes/media";
    };
    database.createLocally = true;
  };

  systemd.services.tandoor-recipes = {
    requires = [ "postgresql.target" ];
    after = [ "postgresql.target" ];
    serviceConfig = {
      EnvironmentFile = "/etc/tandoor-recipes/secrets.env";
    };
  };

  services.caddy.virtualHosts."tandoor.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8080
  '';
}
