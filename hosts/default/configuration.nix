{ inputs, pkgs, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.hyprland.nixosModules.default
  ];

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
    gnome.gnome-keyring
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
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

    efibootmgr
    # dolphin
    samba
    gnome.seahorse
    libsForQt5.ark
    gparted

    qbittorrent
    ffmpeg-full

    discord
    # Discord screensharing with audio in Wayland
    vesktop

    pavucontrol
  ];


  # TODO: further XDG config and move to module
  services.dbus.enable = true;
  xdg = {
    mime = {
      addedAssociations = {
        "x-scheme-handler/vscode" = [ "code-url-handler.desktop" ];
      };
      defaultApplications = {
        "x-scheme-handler/vscode" = [ "code-url-handler.desktop" ];
      };
    };
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
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

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gvfs;
  };
  services.tumbler.enable = true;

  services.gnome.gnome-keyring.enable = true;
}
