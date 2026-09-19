{ pkgs, ... }:

{
  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "terminal"

    [keys]
    prefix = "ctrl+a"

    [ui]
    prompt_new_tab_name = false
  '';
}
