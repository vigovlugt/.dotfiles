{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.vigo = {
      isDefault = true;
    };
  };
}
