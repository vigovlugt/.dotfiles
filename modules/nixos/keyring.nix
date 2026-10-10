{ ... }:

{
  # Secret Service for Chrome, VS Code, Cursor, Slack, ...
  # Also unlocks the login keyring via the `login` PAM service, which greetd includes.
  services.gnome.gnome-keyring.enable = true;
}
