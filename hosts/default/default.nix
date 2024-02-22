{ config, inputs, pkgs, lib, ... }:

{
  options = {
    script-config.nixos-config-home = lib.mkOption {
      description = "NixOS config home on the system";
      type = lib.types.str;
    };
    script-config.media-processor.enable = lib.mkOption {
      description = "Enable the transcoder and renamer scripts";
      type = lib.types.bool;
      default = false;
    };
    script-config.media-processor.work-dir = lib.mkOption {
      description = "Where to output. It should be an absolute path **string**";
      type = lib.types.str;
    };

    install-level = lib.mkOption {
      description = "Installation level (minimal / full install)";
      type = lib.types.enum [ "minimal" "full" ];
      default = "full";
    };
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Configure keymap in X11
    # Wayland uses Xorg keyboard configuration
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      cifs-utils
      e2fsprogs
      efibootmgr
      gnupg
      nano
    ];

    security.polkit = {
      enable = true;
      adminIdentities = [ "unix-group:wheel" ];
    };
    services.dbus.enable = true;
    services.gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gvfs;
    };
    services.tumbler.enable = true;

    # Printing
    services.printing.enable = config.install-level == "full";
    services.avahi =
      let
        full-install = config.install-level == "full";
      in
      lib.mkIf full-install {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
  };
}
