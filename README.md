## Installation new machine

1. Install graphical ISO image from https://nixos.org/download/
2. Complete NixOS install
3. Run `sudo passwd && sudo systemctl start sshd && ip addr show`
4. Copy `cat /etc/nixos/hardware-configuration.nix` to local machine and add it to modules
5. Add ssh to `nano /etc/nixos/configuration.nix`
6. Run `sudo nixos-rebuild switch`
7. On desktop run `nixos-rebuild switch --flake .#NIXOSSYSTEM --target-host root@IP --build-host localhost`

## Anakin configuration

See [./anakin/README.md](./anakin/README.md)

## Windows
```
winget install -e --id Mozilla.Firefox
winget install -e --id Discord.Discord
winget install -e --id RiotGames.LeagueOfLegends.EUW
winget install -e --id Nvidia.GeForceNow
```

Install https://www.nvidia.com/en-us/software/nvidia-app/
