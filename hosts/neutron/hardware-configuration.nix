# You should use your own hardware configuration.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" =
      { device = "/dev/disk/by-uuid/56e3ad80-752d-4b2b-8dfc-c888620d492a";
        fsType = "ext4";
      };

    "/boot/efi" =
      { device = "/dev/disk/by-uuid/5489-AD6B";
        fsType = "vfat";
      };

    "/home" =
      { device = "/dev/disk/by-uuid/954990af-b505-496a-aefd-6576df2d709c";
        fsType = "ext4";
      };

    "/media/memebigboi" =
      { device = "/dev/disk/by-uuid/756194cd-2313-4e2e-8d2f-52dc3def00bd";
        fsType = "ext4";
        options = [ "defaults" "rw" "nofail" ];
      };

    "/media/game_1" =
      { device = "/dev/disk/by-uuid/ad69d529-e1b8-4754-8162-37a65745cb9f";
        fsType = "ext4";
        options = [ "defaults" "rw" "nofail" ];
      };
  };

  swapDevices = [ {
    device = "/dev/disk/by-uuid/2dc00021-5764-46fd-a801-2481e8c48b5e";
  } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
