{ ... }:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "google_translate" # TTS
      "met" # weather
      "isal" # better compression
      "samsungtv"
      "cast"
      "spotify"
      "matter"
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
  services.matter-server = {
    enable = true;
  };

  services.caddy.virtualHosts."hass.vigovlugt.com".extraConfig = ''
    reverse_proxy :8123
  '';
}
