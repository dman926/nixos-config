{ inputs
, pkgs
, lib
, ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    ./hardware-configuration.nix
    (import ./disks.nix { device = "/dev/nvme0n1"; })

    ../../nixos
    ../../nixos/users/dj
    ../../nixos/users/tmpuser
  ];

  networking.hostName = "electron";

  modules.nixos = {
    # avahi.enable = true;
    # auto-hibernate.enable = false;
    # backup.enable = true;
    bluetooth.enable = true;
    # docker.enable = true;
    fingerprint.enable = true;
    # gaming.enable = true;
    login.enable = true;
    # extraSecurity.enable = true;
    power.enable = true;
    virtualisation.enable = true;
    # vpn.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-rebuild
  ];

  # swapDevices = [{ device = "/dev/disk/by-partlabel/disk-main-swap"; }];
  boot = {
    blacklistedKernelModules = [ "hid-sensor-hub" ];
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      # efi = {
      #   canTouchEfiVariables = true;
      #   efiSysMountPoint = "/boot/efi";
      # };
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
    # resumeDevice = "/dev/disk/by-label/nixos";
  };

  boot.plymouth = {
    enable = true;
    themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
    theme = "catppuccin-mocha";
  };
  # boot.initrd.systemd.enable = true;

  system.stateVersion = "23.11";
}
