{ config, pkgs, ... }:

{
  networking.hostName = "vigo-desktop-nixos";

  # Disable ACPI wake-up for GPP0 and GPP8 to prevent unwanted wake-ups
  systemd.services.disable-acpi-wakeup = {
    description = "Disable ACPI wake-up for GPP0 and GPP8";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo GPP0 > /proc/acpi/wakeup && echo GPP8 > /proc/acpi/wakeup'";
      RemainAfterExit = true;
    };
  };
}
