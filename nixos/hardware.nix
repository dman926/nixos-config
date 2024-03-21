{ config, pkgs, ... }:

{
  services.printing.enable = true;
  services.hardware.bolt.enable = builtins.elem "thunderbolt" config.boot.initrd.availableKernelModules;
  hardware = {
    enableAllFirmware = true;
    ledger.enable = true;
    keyboard.qmk.enable = true;
    gpgSmartcards.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  services.geoclue2.enable = true;
  environment.pathsToLink = [
    "/share/bash"
  ];
}
