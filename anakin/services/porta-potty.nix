{ ... }:

{
  services.porta-potty = {
    enable = true;
    environmentFile = "/etc/porta-potty/secrets.env";
  };
}
