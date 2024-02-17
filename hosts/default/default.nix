{ config, inputs, pkgs, lib, ... }:

{
  options = {
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
