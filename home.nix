{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vigovlugt";
  home.homeDirectory = "/home/vigovlugt";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    discord
    spotify
    kitty
    vscode
    nodejs
    pnpm
    nixd
    nixpkgs-fmt
    htop
    neofetch
    wl-clipboard
    gcc
    rustup
    gdu
    jdk
    pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --gtk-dark --show drun";
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
	"$mod SHIFT, Q, killactive,"
	"$mod, E, exec, $fileManager"
	"$mod SHIFT, Space, togglefloating," "$mod, Space, exec, $menu" "$mod, F, fullscreen,"
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
	"$mod, ', exec, firefox"
	", Print, exec, grimblast copy area"
      ];
      bindm = [
	"$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindow"
      ];
      misc = {
	force_default_wallpaper = "0";
	disable_hyprland_logo = "true";
      };
      windowrulev2 = "suppressevent maximize, class:.*";
      dwindle = {
	preserve_split = "true";
      };
      animations = {
	enabled= "false";
      };
      exec-once = "waybar";
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
	layer = "top";
	modules-left = ["hyprland/workspaces"];
	modules-center = ["hyprland/window"];
	modules-right = ["mpd" "pulseaudio" "network" "backlight" "battery" "clock" "tray"];
	"hyprland/window" = {
	    max-length = 50;
	};
	battery = {
	    format = "{capacity}% {icon}";
	    format-icons = ["" "" "" "" ""];
	};
	clock = {
	    format-alt = "{:%a, %d. %b  %H:%M}";
	};
      };
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
      update = "sudo nixos-rebuild switch --flake ~/.dotfiles";
      windows = "systemctl reboot --boot-loader-entry=auto-windows";
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


  # Install firefox.
  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./init.lua;
  };

  programs.git = {
    enable = true;
    userName  = "vigovlugt";
    userEmail = "vigovlugt@gmail.com";
    lfs.enable = true;
    extraConfig = {
      push = { autoSetupRemote = true; };
      init = { defaultBranch = "main"; };
    };
  };

  programs.gh.enable = true;

  manual.json.enable = true;

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
