{ ... }:

{
  xdg.desktopEntries.config = {
    name = "Config";
    comment = "Open ~/.dotfiles in Cursor";
    exec = "sh -c \"cursor ~/.dotfiles\"";
    terminal = false;
    categories = [ "Utility" ];
  };
}
