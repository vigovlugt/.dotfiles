{ ... }:

{
  imports = [
    ../modules/home/base.nix
    ../modules/home/zsh.nix
    ../modules/home/tmux.nix
    ../modules/home/git.nix
    ../modules/home/neovim.nix
    ../modules/home/zoxide.nix
    ../modules/home/packages.nix
    ../modules/home/hyprland.nix
    ../modules/home/waybar.nix
    ../modules/home/mako.nix
    ../modules/home/firefox.nix
    ../modules/home/ghostty.nix
    ../modules/home/thunderbird.nix
    ../modules/home/hyprlock.nix
    ../modules/home/vicinae.nix
    ../modules/home/desktop-entries.nix
  ];

  # Desktop-specific zsh aliases (merged with shared aliases from modules/home/zsh.nix)
  programs.zsh.shellAliases = {
    windows = "systemctl reboot --boot-loader-entry=auto-windows";
    config = "cursor ~/.dotfiles";
    upgrade-anakin = "nixos-rebuild switch --flake ~/.dotfiles --target-host root@anakin --build-host root@anakin";
    nixdev = "nix develop --command $SHELL";
    collect-garbage = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
  };

  home.stateVersion = "24.05";
}
