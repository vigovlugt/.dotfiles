{ ... }:

{
  home.username = "vigovlugt";
  home.homeDirectory = "/home/vigovlugt";

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.home-manager.enable = true;
}
