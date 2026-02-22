{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Cursor Dark";
      shell-integration-features = "ssh-terminfo";
    };
  };
}
