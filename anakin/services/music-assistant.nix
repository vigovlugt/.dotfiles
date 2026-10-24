{ config, pkgs, ... }:

let
  # nixpkgs' librespot.patch only half-applies on 2.10.3: it still looks for the bundled
  # bin/librespot-linux-x86_64 (which is removed) instead of librespot from PATH.
  # Bind-mount a fixed helpers.py over the original instead of rebuilding the package.
  spotifyHelpers = "${config.services.music-assistant.package}/${pkgs.python3.sitePackages}/music_assistant/providers/spotify/helpers.py";
  fixedSpotifyHelpers = pkgs.runCommand "music-assistant-spotify-helpers.py" { } ''
    substitute ${spotifyHelpers} $out \
      --replace-fail 'os.path.join(base_path, f"librespot-{system}-{architecture}")' 'which("librespot")'
  '';
in

{
  services.music-assistant = {
    enable = true;
    providers = [
      "spotify"
      "spotify_connect"
      "chromecast"
      "sonos"
      "universal_group"
    ];
  };

  # nixpkgs builds from source without Music Assistant's bundled app_secrets.json, so the
  # Spotify client ID is empty; use our own Spotify app (redirect URI https://music-assistant.io/callback)
  systemd.services.music-assistant.environment.MASS_APP_VAR_SPOTIFY_CLIENT_ID = "cff69f1a5dd44b599a69b3f0f3b13a44";

  systemd.services.music-assistant.serviceConfig.BindReadOnlyPaths = [
    "${fixedSpotifyHelpers}:${spotifyHelpers}"
  ];

  services.caddy.virtualHosts."music-assistant.vigovlugt.com".extraConfig = ''
    reverse_proxy :8095
  '';
}
