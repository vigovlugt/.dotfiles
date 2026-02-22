{ ... }:

{
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };

  systemd.services.docker.enable = false;
}
