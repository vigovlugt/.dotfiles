{ ... }:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "google_translate" # TTS
      "met" # weather
      "isal" # better compression
      "music_assistant"
      "samsungtv"
      "cast"
      "spotify"
    ];
    config = {
      default_config = { };
      http = {
        base_url = "https://hass.vigovlugt.com";
        use_x_forwarded_for = true;
        trusted_proxies = "127.0.0.1";
      };
    };
  };

  services.caddy.virtualHosts."hass.vigovlugt.com".extraConfig = ''
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :8123
  '';
}
