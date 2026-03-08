{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "vicinae toggle";
      "$browser" = "firefox";
      "$colorpicker" = "hyprpicker --autocopy";
      bind = [
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 0"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 0"
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive,"
        "$mod, E, exec, $fileManager"
        "$mod SHIFT, Space, togglefloating,"
        "$mod, Space, exec, $menu"
        "$mod, F, fullscreen,"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "$mod, apostrophe, exec, $browser"
        "$mod, L, exec, loginctl lock-session"
        "$mod SHIFT, S, exec, grimblast copy area"
        "$mod SHIFT, C, exec, $colorpicker"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
        layout = "master";
      };
      cursor = {
        no_hardware_cursors = "true";
      };
      input = {
        force_no_accel = 1;
      };
      misc = {
        force_default_wallpaper = "0";
        disable_hyprland_logo = "true";
      };
      windowrule = [
        "workspace 2 silent, match:class ^(discord)$"
        "workspace 4 silent, match:class ^(Code|code|code-url-handler|Cursor|cursor|cursor-url-handler)$"
      ];
      animations = {
        enabled = "false";
      };
      exec-once = [
        "waybar"
        "mako"
        "vicinae server"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] discord"
        "[workspace 3 silent] $terminal"
      ];
    };
  };
}
