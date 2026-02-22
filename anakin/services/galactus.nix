{ ... }:

{
  services.galactus = {
    enable = true;
    environmentFile = "/etc/galactus/secrets.env";
    settings = {
      port = 1337;
      base_url = "https://galactus.vigovlugt.com";
      jukebox = {
        device_name = "Q-Series Soundbar";
        album_map = {
          "01 22 4C 54" = "spotify:album:5WulAOx9ilWy1h8UGZ1gkI"; # Deadbeat
          "FE E9 9C 1E" = "spotify:album:0U0Qv2jYtsgGxFDpQJKAxQ"; # Ego death at a bachelorette party
          "E6 0A 9C 1E" = "spotify:album:5vkqYmiPBYLaalcmjujWxK"; # In rainbows
          "16 10 9C 1E" = "spotify:album:3HFbH1loOUbqCyPsLuHLLh"; # Room on fire
          "F4 C5 9C 1E" = "spotify:album:78bpIziExqiI9qztvNFlQu"; # AM
          "F4 30 9C 1E" = "spotify:album:4LH5M9xS4kK1HKvalSNJVo"; # Galore
          "0B 7C 9C 1E" = "spotify:album:4TQqRcEliluExEwsmWVenF"; # Choke enough
          "E3 0B 9C 1E" = "spotify:album:6trNtQUgC8cgbWcqoMYkOR"; # Beerbongs & Bentleys
          "C7 B5 9C 1E" = "spotify:album:5mIImcsuqpiSXg8XvFr81I"; # Ballads 1
          "D7 0D 9C 1E" = "spotify:album:2lIZef4lzdvZkiiCzvPKj7"; # Is this it
          "B9 24 9D 1E" = "spotify:album:4m2880jivSbbyEGAKfITCa"; # Random Access Memories
          "A6 28 9C 1E" = "spotify:album:79dL7FLiJFOO0EoehUHQBv"; # Currents
          "31 3C 9C 1E" = "spotify:album:3C2MFZ2iHotUQOSBzdSvM7"; # Lonerism
          "96 9C 9C 1E" = "spotify:album:1DNSmmRLfv97Yjq7MTFWng"; # Innerspeaker
          "7E BA 9C 1E" = "spotify:album:1amYhlukNF8WdaQC3gKkgL"; # The now now
          "0B 23 9D 1E" = "spotify:album:6dVIqQ8qmQ5GBnJ9shOYGE"; # OK Computer
          "35 4B 9D 1E" = "spotify:album:0NvirtaDCaZU5PAW1O5FDE"; # Humanz
          "F2 14 9D 1E" = "spotify:album:50Zz8CkIhATKUlQMbHO3k1"; # Whatever people say I am, that's what I'm not
          "A7 25 9C 1E" = "spotify:album:1XkGORuUX2QGOEIL4EbJKm"; # Favourite Worst Nightmare
          "F5 EA 9B 1E" = "spotify:album:0XJBeAQSVAZ5yjApvKl2JL"; # Scandinavian boy
          "F4 DA 9C 1E" = "spotify:album:260VIHFdGNsHL3DKUZYYkc"; # Albino
          "8C ED 9C 1E" = "spotify:album:5s0rmjP8XOPhP6HhqOhuyC"; # Stoney
          "7C E1 E2 2E" = "spotify:album:1G40QqbxYWEeelWqf4hpbI"; # Breakfast in America
          "BD 35 9D 1E" = "spotify:album:6pTMhQX8gt1xegiIwo3Ekb"; # Fire on Marzz
        };
      };
    };
  };

  services.caddy.virtualHosts."galactus.vigovlugt.com".extraConfig = ''
    tls {
      dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    reverse_proxy :1337
  '';
}
