{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "vigovlugt";
      user.email = "vigovlugt@gmail.com";
      push = {
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
    lfs.enable = true;
  };

  programs.gh.enable = true;
}
