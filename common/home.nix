{ pkgs, ... }:

{
  imports = [
    ../modules/home/base.nix
    ../modules/home/zsh.nix
    ../modules/home/tmux.nix
    ../modules/home/git.nix
    ../modules/home/neovim.nix
    ../modules/home/zoxide.nix
  ];

  # Desktop-specific zsh aliases (merged with shared aliases from modules/home/zsh.nix)
  programs.zsh.shellAliases = {
    windows = "systemctl reboot --boot-loader-entry=auto-windows";
    config = "cursor ~/.dotfiles";
    upgrade-anakin = "nixos-rebuild switch --flake ~/.dotfiles --target-host root@anakin --build-host root@anakin";
    nixdev = "nix develop --command $SHELL";
    collect-garbage = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
  };

  home.packages = with pkgs; [
    discord
    vesktop
    spotify
    kitty
    vscode
    # zed-editor
    code-cursor
    nixd
    nixpkgs-fmt
    htop
    btop
    neofetch
    wl-clipboard
    gdu
    ripgrep
    fd
    bat
    google-chrome
    qbittorrent
    vlc
    slack
    bombardier
    air
    websocat
    bun
    k6
    brightnessctl
    hyprpicker
    # jellyfin-media-player
    pulumi
    pulumiPackages.pulumi-nodejs
    arduino-ide
    arduino-cli
    arduino
    heroic
    pulumi
    android-tools

    # Languages
    nodejs
    pnpm
    gcc
    rustup
    jdk
    python3
    go
    zig
    # dotnet-sdk_8
    nil
    nixd

    gopls
    delve
    golangci-lint
    uv
    omnisharp-roslyn
    roslyn-ls
    vue-language-server
    lua-language-server
    typescript-language-server
    prettierd
    eslint_d
    nixfmt
    sqlite
    protobuf
    protoc-gen-go
    protoc-gen-js
    protoc-gen-go-grpc
    grpcurl
    gnumake
    obsidian
    bind # nslookup, dig
    jq
    opencode

    # jetbrains.rider
    # android-studio
    android-tools
    # azure-cli
    pavucontrol
    unzip
    grimblast
    nmap
    kdePackages.dolphin
    prismlauncher
  ];

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
      windowrule = "workspace 2 silent, match:class discord";
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

  services.mako = {
    enable = true;
    settings = {
      actions = true;
      border-radius = 6;
      border-size = 1;
      border-color = "#23252a";
      background-color = "#101012";
      default-timeout = 10000;
      font = "FontAwesome, Inter";
      padding = "10,12";
    };
  };

  programs.firefox.enable = true;

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Cursor Dark";
      shell-integration-features = "ssh-terminfo";
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles.vigo = {
      isDefault = true;
    };
  };

  xdg.desktopEntries.config = {
    name = "Config";
    comment = "Open ~/.dotfiles in Cursor";
    exec = "sh -c \"cursor ~/.dotfiles\"";
    terminal = false;
    categories = [ "Utility" ];
  };

  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
  };

  home.stateVersion = "24.05";
}
