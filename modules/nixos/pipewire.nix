{ ... }:

{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."custom" = {
      "context.properties" = {
        "default.clock.quantum" = 2048;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 4096;
      };
    };
  };
}
