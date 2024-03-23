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
    auto-hibernate.enable = true;
    # avahi.enable = true;
    # backup.enable = true;
    bluetooth.enable = true;
    docker.enable = true;
    fingerprint.enable = true;
    # gaming.enable = true;
    login.enable = true;
    hardening.enable = true;
    power.enable = true;
    virtualisation.enable = true;
    # TODO: Move to home manager
    # vpn.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-rebuild
  ];

  boot = {
    blacklistedKernelModules = [ "hid-sensor-hub" ];
    supportedFilesystems = lib.mkForce [ "btrfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  boot.plymouth = {
    enable = true;
    themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
    theme = "catppuccin-mocha";
  };

  system.stateVersion = "23.11";
}
