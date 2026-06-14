{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false; # 26.05 default
    withRuby = false; # 26.05 default
  };
}
