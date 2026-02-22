{ pkgs, ... }:

{
  users.users.vigovlugt = {
    isNormalUser = true;
    description = "Vigo Vlugt";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "vigovlugt" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
