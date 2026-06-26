{ ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "vigovlugt";
    group = "users";
    dataDir = "/home/vigovlugt";
    settings = {
      devices.anakin.id = "CZHEWAX-HCNZZ36-QO2CDTM-NGTXMZR-6KVBFSZ-RUCQMX2-TXIC57X-H5TCYQK";
      folders.notes = {
        path = "/home/vigovlugt/Documents/notes";
        devices = [ "anakin" ];
      };
    };
  };
}
