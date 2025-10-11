{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vigovlugt";
  home.homeDirectory = "/home/vigovlugt";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    discord
    vesktop
    spotify
    kitty
    ghostty
    vscode
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
    # jellyfin-media-player
    pulumi
    pulumiPackages.pulumi-nodejs

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
    pkgs.nixfmt-rfc-style
    sqlite
    protobuf
    protoc-gen-go
    protoc-gen-js
    protoc-gen-go-grpc
    grpcurl
    gnumake

    # jetbrains.rider
    # android-studio
    # android-tools
    # azure-cli
    pavucontrol
    unzip
    grimblast
    nmap
    kdePackages.dolphin
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --gtk-dark --show drun";
      "$browser" = "firefox";
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
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "$mod, apostrophe, exec, $browser"
        "$mod, L, exec, loginctl lock-session"
        ", Print, exec, grimblast copy area"
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
      # windowrulev2 = "suppressevent maximize, class:.*";
      # dwindle = {
      #   preserve_split = "true";
      # };
      animations = {
        enabled = "false";
      };
      exec-once = [
        "waybar"
        "mako"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] discord"
      ];
    };
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   x11.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Ice";
  #   size = 16;
  # };

  # gtk = {
  #   enable = true;

  #   theme = {
  #     package = pkgs.flat-remix-gtk;
  #     name = "Flat-Remix-GTK-Grey-Darkest";
  #   };

  #   iconTheme = {
  #     package = pkgs.adwaita-icon-theme;
  #     name = "Adwaita";
  #   };

  #   font = {
  #     name = "Sans";
  #     size = 11;
  #   };
  # };

  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock & systemctl suspend"; # avoid starting multiple hyprlock instances.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
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

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      upgrade = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      update = "nix flake update --flake ~/.dotfiles";
      windows = "systemctl reboot --boot-loader-entry=auto-windows";
      config = "cursor ~/.dotfiles && exit";
      jellyfin = "ssh raspberrypi -t 'cd ~/media-server && docker compose down && docker compose up -d jellyfin'";
      radarr = "ssh raspberrypi -t 'cd ~/media-server && docker compose down && docker compose up -d radarr qbittorrent prowlarr'";
      sonarr = "ssh raspberrypi -t 'cd ~/media-server && docker compose down && docker compose up -d sonarr qbittorrent prowlarr'";
      nixdev = "nix develop --command $SHELL";
    };
    sessionVariables = {
      ANDROID_HOME = "/home/vigovlugt/Android/Sdk/";
    };
    # history = {
    # size = 10000;
    # path = "${config.xdg.dataHome}/zsh/history";
    # };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      set -g base-index 1
      setw -g pane-base-index 1

      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };

  programs.zoxide.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
    userName = "vigovlugt";
    userEmail = "vigovlugt@gmail.com";
    lfs.enable = true;
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gh.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
