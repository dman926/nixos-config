{ inputs
, pkgs
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    (import ./disks.nix {
      inherit lib;
      # TODO: Check devices
      device = "/dev/nvme0n1";
      hardStorageDevice = "/dev/sda";
      gameDevice = "/dev/sdb";
    })

    ../../nixos
    ../../nixos/users/dj
    ../../nixos/users/tmpuser
  ];

  networking.hostName = "hydrogen";

  modules.nixos = {
    # avahi.enable = true;
    # backup.enable = true;
    bluetooth.enable = true;
    docker.enable = true;
    fingerprint.enable = true;
    gaming.enable = true;
    hardening.enable = true;
    login.enable = true;
    nvidia = {
      enable = true;
      enableCuda = true;
    };
    power.enable = true;
    virtualisation.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-rebuild
    media-processor
    virt-manager
  ];

  boot = {
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
    themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "circuit" ]; }) ];
    theme = "circuit";
  };

  system.stateVersion = "23.11";
}
