{ ... }:

{
  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = false;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock & systemctl suspend";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
