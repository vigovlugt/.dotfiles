{ pkgs, ... }:

{
  imports = [
    ../modules/home/base.nix
    ../modules/home/zsh.nix
    ../modules/home/tmux.nix
    ../modules/home/git.nix
    ../modules/home/neovim.nix
    ../modules/home/zoxide.nix
  ];

  home.packages = with pkgs; [
    btop
  ];

  home.stateVersion = "24.11";
}
