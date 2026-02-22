# NixOS Config Modularization Plan

Split monolithic NixOS configuration files into one-module-per-program/service, with shared base modules to eliminate duplication between hosts.

## Current State

| File | Lines | Problem |
|---|---|---|
| `common/home.nix` | 472 | Monolithic: packages, hyprland, waybar, zsh, tmux, git, etc. |
| `anakin/configuration.nix` | 419 | Monolithic: all server services in one file |
| `common/configuration.nix` | 262 | Monolithic: NVIDIA, audio, gaming, docker, etc. |
| `anakin/home.nix` | 86 | Duplicates zsh, tmux, git, neovim from common/ |

## Target Structure

```
.dotfiles/
  flake.nix                              (unchanged)

  modules/
    nixos/
      base.nix                           # locale, timezone, nix settings, allowUnfree, keyboard
      boot.nix                           # systemd-boot, EFI
      networking.nix                     # NetworkManager, firewall
      user.nix                           # user account, sudo, default shell
      nvidia.nix                         # NVIDIA drivers, session vars, OpenGL, xserver drivers
      pipewire.nix                       # PipeWire, rtkit, custom quantum config
      bluetooth.nix                      # bluetooth + blueman
      printing.nix                       # CUPS
      steam.nix                          # Steam + gamescope
      hyprland.nix                       # programs.hyprland, greetd/tuigreet, XDG portals
      kde.nix                            # KDE Plasma 6, SDDM, xserver
      docker.nix                         # Docker
      tailscale.nix                      # Tailscale
      avahi.nix                          # Avahi/mDNS
      libvirtd.nix                       # libvirtd + virt-manager
      nh.nix                             # nh NixOS helper
      teamviewer.nix                     # TeamViewer
      nix-ld.nix                         # nix-ld
      fonts.nix                          # Font packages
      swap.nix                           # Swapfile
      libinput.nix                       # Touchpad
      openssh.nix                        # SSH server
    home/
      base.nix                           # home-manager enable, username, homeDir, stateVersion, dconf
      zsh.nix                            # zsh + oh-my-zsh + aliases
      tmux.nix                           # tmux config
      git.nix                            # git + gh
      neovim.nix                         # neovim
      zoxide.nix                         # zoxide
      firefox.nix                        # firefox
      ghostty.nix                        # ghostty terminal
      thunderbird.nix                    # thunderbird
      waybar.nix                         # waybar config + CSS
      mako.nix                           # mako notifications
      hyprland.nix                       # hyprland WM settings, keybinds, window rules
      hyprlock.nix                       # hyprlock + hypridle
      vicinae.nix                        # vicinae app launcher
      packages.nix                       # user packages list
      desktop-entries.nix                # custom .desktop files

  anakin/
    services/
      caddy.nix                          # Caddy base config (cloudflare plugin, env file)
      home-assistant.nix                 # Home Assistant + caddy vhost
      music-assistant.nix                # Music Assistant + caddy vhost
      opencloud.nix                      # OpenCloud + caddy vhost
      couchdb.nix                        # CouchDB + caddy vhost
      postgresql.nix                     # PostgreSQL
      tandoor.nix                        # Tandoor Recipes + caddy vhost
      immich.nix                         # Immich + caddy vhost
      actual.nix                         # Actual Budget + caddy vhost
      openobserve.nix                    # OpenObserve + caddy vhost
      opencode-web.nix                   # OpenCode web + caddy vhost
      restic.nix                         # Restic backup/prune/check services + timers
      galactus.nix                       # Galactus NFC jukebox + caddy vhost
      porta-potty.nix                    # Porta-potty service
    hardware-configuration.nix           (unchanged)
    configuration.nix                    # thin: imports base modules + services/
    home.nix                             # thin: imports shared home modules + btop

  common/
    configuration.nix                    # thin: imports desktop-relevant nixos modules
    home.nix                             # thin: imports desktop-relevant home modules

  cassian/                               (unchanged)
  laptop/                                (unchanged)
```

## Design Decisions

### Shared base vs desktop-only modules
- `modules/nixos/base.nix` — imported by ALL hosts (locale, timezone, nix settings, keyboard, allowUnfree)
- `modules/nixos/user.nix` — imported by ALL hosts (user account; desktop hosts add extra groups via mkMerge in their own configs)
- Desktop-only modules (nvidia, steam, kde, hyprland, etc.) — imported only by `common/configuration.nix`

### Handling zsh alias differences
- `modules/home/zsh.nix` contains shared zsh config (oh-my-zsh, completion, syntax highlighting) with only the universal aliases (`upgrade`, `update`)
- Desktop-specific aliases (`windows`, `config`, `upgrade-anakin`, `nixdev`, `collect-garbage`) are added in `common/home.nix` via `programs.zsh.shellAliases` merge

### Handling tmux differences
- anakin has 2 extra lines (`unbind -n Tab`, `set -s escape-time 0`). These are harmless on desktop, so `modules/home/tmux.nix` includes the full config (anakin's version). This eliminates duplication entirely.

### Caddy service pattern for anakin
- `anakin/services/caddy.nix` defines the base Caddy config (package with cloudflare plugin, environment file)
- Each service file adds its own `services.caddy.virtualHosts."..."` entry
- NixOS module system merges all virtualHosts automatically

### flake.nix stays the same
- `common/configuration.nix` and `common/home.nix` remain the aggregation points (now just import lists)
- `anakin/configuration.nix` and `anakin/home.nix` become thin import lists
- The flake continues to reference `common/*`, `cassian/*`, `laptop/*`, `anakin/*` as before

---

## Milestones

### Milestone 1: Create shared base modules (nixos + home)

Extract settings shared by ALL hosts into base modules. This eliminates the duplication between `common/` and `anakin/`.

**Files to create:**
- `modules/nixos/base.nix` — locale, timezone, nix settings, allowUnfree, keyboard layout
- `modules/nixos/boot.nix` — systemd-boot, EFI
- `modules/nixos/networking.nix` — NetworkManager, firewall
- `modules/nixos/user.nix` — user account (minimal groups), sudo, zsh as default shell
- `modules/nixos/tailscale.nix` — Tailscale
- `modules/nixos/avahi.nix` — Avahi/mDNS
- `modules/home/base.nix` — home-manager enable, username, homeDir, stateVersion, dconf dark theme
- `modules/home/zsh.nix` — zsh + oh-my-zsh (shared aliases only)
- `modules/home/tmux.nix` — tmux (full config including anakin extras)
- `modules/home/git.nix` — git + gh
- `modules/home/neovim.nix` — neovim
- `modules/home/zoxide.nix` — zoxide

**Files to modify:**
- `anakin/configuration.nix` — replace duplicated base settings with `imports`
- `anakin/home.nix` — replace duplicated home settings with `imports`

**Validation:** `anakin` config produces identical system after rebuild.

---

### Milestone 2: Split common/configuration.nix into desktop nixos modules

Break the desktop-specific system config into per-concern modules.

**Files to create:**
- `modules/nixos/nvidia.nix` — NVIDIA drivers, session vars, OpenGL, xserver video drivers
- `modules/nixos/pipewire.nix` — PipeWire, PulseAudio disable, rtkit, custom quantum
- `modules/nixos/bluetooth.nix` — bluetooth + blueman
- `modules/nixos/printing.nix` — CUPS
- `modules/nixos/steam.nix` — Steam + gamescope
- `modules/nixos/hyprland.nix` — programs.hyprland, greetd/tuigreet, XDG portals
- `modules/nixos/kde.nix` — KDE Plasma 6, SDDM, xserver.enable
- `modules/nixos/docker.nix` — Docker
- `modules/nixos/libvirtd.nix` — libvirtd + virt-manager
- `modules/nixos/nh.nix` — nh NixOS helper
- `modules/nixos/teamviewer.nix` — TeamViewer
- `modules/nixos/nix-ld.nix` — nix-ld
- `modules/nixos/fonts.nix` — font packages
- `modules/nixos/swap.nix` — swapfile
- `modules/nixos/libinput.nix` — touchpad
- `modules/nixos/openssh.nix` — SSH server (for anakin too)

**Files to modify:**
- `common/configuration.nix` — replace monolithic config with `imports = [...]` list

**Validation:** `cassian` and `laptop` configs produce identical systems after rebuild.

---

### Milestone 3: Split common/home.nix into desktop home modules

Break the desktop-specific Home Manager config into per-program modules.

**Files to create:**
- `modules/home/packages.nix` — user packages list
- `modules/home/hyprland.nix` — hyprland WM settings, keybinds, window rules
- `modules/home/waybar.nix` — waybar config + CSS
- `modules/home/mako.nix` — mako notifications
- `modules/home/firefox.nix` — firefox
- `modules/home/ghostty.nix` — ghostty terminal
- `modules/home/thunderbird.nix` — thunderbird
- `modules/home/hyprlock.nix` — hyprlock + hypridle
- `modules/home/vicinae.nix` — vicinae app launcher
- `modules/home/desktop-entries.nix` — custom .desktop files

**Files to modify:**
- `common/home.nix` — replace monolithic config with `imports = [...]` list + desktop-specific zsh aliases

**Validation:** `cassian` and `laptop` configs produce identical systems after rebuild.

---

### Milestone 4: Split anakin/configuration.nix into service modules

Break the server config into one-file-per-service.

**Files to create:**
- `anakin/services/caddy.nix` — Caddy base config
- `anakin/services/home-assistant.nix` — Home Assistant + caddy vhost
- `anakin/services/music-assistant.nix` — Music Assistant + caddy vhost
- `anakin/services/opencloud.nix` — OpenCloud + caddy vhost
- `anakin/services/couchdb.nix` — CouchDB + caddy vhost
- `anakin/services/postgresql.nix` — PostgreSQL
- `anakin/services/tandoor.nix` — Tandoor Recipes + caddy vhost
- `anakin/services/immich.nix` — Immich + caddy vhost
- `anakin/services/actual.nix` — Actual Budget + caddy vhost
- `anakin/services/openobserve.nix` — OpenObserve + caddy vhost
- `anakin/services/opencode-web.nix` — OpenCode web + caddy vhost
- `anakin/services/restic.nix` — Restic backup/prune/check
- `anakin/services/galactus.nix` — Galactus NFC jukebox + caddy vhost
- `anakin/services/porta-potty.nix` — Porta-potty

**Files to modify:**
- `anakin/configuration.nix` — replace service definitions with imports from `services/`

**Validation:** `anakin` config produces identical system after rebuild.

---

### Milestone 5: Cleanup

- Remove commented-out code blocks scattered across modules
- Remove stale comments (e.g., "Did you read the comment?")
- Verify no orphaned config remains
- Final review of all import chains

---

## Expected Results

| File | Before | After |
|---|---|---|
| `common/configuration.nix` | 262 lines | ~25 lines (imports only) |
| `common/home.nix` | 472 lines | ~20 lines (imports + desktop aliases) |
| `anakin/configuration.nix` | 419 lines | ~15 lines (imports only) |
| `anakin/home.nix` | 86 lines | ~10 lines (imports + btop) |
| New module files | 0 | ~52 files, 5-90 lines each |
| Duplication between anakin and common | ~80 lines | 0 |
