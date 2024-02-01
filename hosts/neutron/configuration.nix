{ pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default

      ../../users/dj

      inputs.sops-nix.nixosModules.sops
      ../../modules/nixos/secrets
      ../../modules/nixos/core
      ../../modules/nixos/greeter
      ../../modules/nixos/keys
      ../../modules/nixos/nvidia
      ../../modules/nixos/openvpn
      ../../modules/nixos/sound
      ../../modules/nixos/steam
    ];

  networking.hostName = "neutron";

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
    cifs-utils
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
    libva

    efibootmgr
    # dolphin
    samba
    gnome.seahorse
    libsForQt5.ark
    gparted

    # CUDA
    cudaPackages.cudatoolkit

    qbittorrent
    ffmpeg-full
    handbrake

    discord
    # Discord screensharing with audio in Wayland
    vesktop

    steam-run

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
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };
  
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gvfs;
  };
  services.tumbler.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
