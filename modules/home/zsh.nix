{ ... }:

{
  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # no-reexec results in the current nixos-rebuild binary being used, rather than the one from the newly build flake
      # This saves 1.3s on my machine (from 13.7s)
      upgrade = "nixos-rebuild switch --flake ~/.dotfiles --sudo --no-reexec";
      update = "nix flake update --flake ~/.dotfiles";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
