{ ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "mpd"
          "pulseaudio"
          "bluetooth"
          "network"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/window" = {
          max-length = 50;
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
        };
      };
    };
    style = ''
          * {
      	border: none;
      	border-radius: 0;
      	font-family: FontAwesome, Inter;
      	font-size: 13px;
      	min-height: 0;
      	color: #e3e4e5;
      	font-weight: 600;
          }

          window#waybar {
      	background: #090909;
          }

          tooltip {
      	background: #090909;
      	border: 1px solid rgba(100, 114, 125, 0.5);
      	border-radius: 6px;
          }
          tooltip label {
      	color: white;
          }

          #workspaces button {
      	padding: 0 5px;
          }

          /* hyprland uses .active instead of .focused */
          #workspaces button.active, #workspaces button.focused {
      	background: #1e1f23;
          }

          #clock,
          #battery,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #wireplumber,
          #custom-media,
          #tray,
          #mode,
          #idle_inhibitor,
          #scratchpad,
          #power-profiles-daemon,
          #mpd,
          #bluetooth {
      	padding: 0 10px;
      	background-color: transparent;
          }
    '';
  };
}
