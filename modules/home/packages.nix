{ pkgs, ... }:

{
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
    heroic
    pulumi
    android-tools

    # Languages
    nodejs
    pnpm
    gcc
    rustup
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
  ];
}
