{ ... }:

{
  programs.firefox = {
    enable = true;
    # Relative to $HOME: this is used as a home.file key, so it must not be absolute.
    configPath = ".config/mozilla/firefox";
  };
}
