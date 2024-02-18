{ config, inputs, pkgs, lib, ... }:

{
  options = {
    script-config.nixos-config-home = lib.mkOption {
      description = "NixOS config home on the system";
      type = lib.types.str;
      default = "$HOME/Documents/github/nixos-config";
    };
    script-config.media-processor.enable = lib.mkOption {
      description = "Enable the transcoder and renamer scripts";
      type = lib.types.bool;
      default = false;
    };
    script-config.media-processor.work-dir = lib.mkOption {
      description = "Where to output";
      type = lib.types.str;
    };

    install-level = lib.mkOption {
      description = "Installation level (minimal / full install)";
      type = lib.types.enum [ "minimal" "full" ];
      default = "full";
    };
    # More of a helper. `install-level` should be used
    full-install = lib.mkOption {
      type = lib.types.bool;
      default = config.install-level == "full";
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

    services.dbus.enable = true;
    services.gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gvfs;
    };
    services.tumbler.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
