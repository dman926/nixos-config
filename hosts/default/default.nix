{ config, inputs, pkgs, lib, ... }:

{
  imports = [
    ./options.nix
  ];

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
}
