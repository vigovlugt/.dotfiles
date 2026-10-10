# Used by the agenix CLI only, not imported into the NixOS config.
# Edit a secret: cd anakin/secrets && agenix -e gatus.env.age
let
  cassian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMoSFdoJdNFgDvjxrlGZW+oi8mOZA++9g4wI3t8oTPJ";
  anakin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILx5dXgoUGjYnfoYo/PbORQqX9LjGAxwRUZkqy/yZ3zY"; # /etc/ssh/ssh_host_ed25519_key.pub
  all = [
    cassian
    anakin
  ];
in
{
  "caddy.env.age".publicKeys = all;
  "gatus.env.age".publicKeys = all;
  "restic.env.age".publicKeys = all;
  "miniflux.env.age".publicKeys = all;
  "galactus.env.age".publicKeys = all;
  "searxng.env.age".publicKeys = all;
  "syncthing-key.pem.age".publicKeys = all;
  "syncthing-cert.pem.age".publicKeys = all;
  "syncthing-gui-password.age".publicKeys = all;
}
