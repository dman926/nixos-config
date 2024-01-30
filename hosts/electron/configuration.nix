{ pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      
      ../../users/dj
      
      # inputs.sops-nix.nixosModules.sops
      # ../../modules/nixos/secrets
      ../../modules/nixos/core
      ../../modules/nixos/greeter
      ../../modules/nixos/keys
      ../../modules/nixos/sound
    ];

  networking.hostName = "electron";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  # Wayland uses Xorg keyboard configuration
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     e2fsprogs
     nano
     gnupg
     xdg-utils
     xdg-desktop-portal-gtk
     xdg-desktop-portal-wlr
     waybar
     # use eww when it gets more complex, waybar works for now
     # eww
     mako
     libnotify # Dependency of mako
     swww
     kitty # TODO: find a better terminal if any
     rofi-wayland
     # Wayland deps
     libsForQt5.qt5.qtwayland # qt5-wayland
     libsForQt5.qt5ct
     libsForQt5.polkit-kde-agent

     efibootmgr
     dolphin
     gnome.seahorse
     libsForQt5.ark
     gparted

     ffmpeg-full
     
     discord
     # Discord screensharing with audio in Wayland
     vesktop

     pavucontrol
   ];
  

  # TODO: further XDG config and move to module
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      # pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    # Wayland/Hyprland vars
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  services.gnome.gnome-keyring.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
