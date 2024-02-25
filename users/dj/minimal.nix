{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.hyprland.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    swww
    kitty # TODO: find a better terminal if any

    libsecret
    polkit_gnome
    gnome.seahorse
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct

    samba
    libsForQt5.ark

    pavucontrol
  ];

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  users.groups.dj = { };

  users.users.dj = {
    isNormalUser = true;
    description = "DJ Stelmach";
    group = "dj";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hasklig" ]; })
      font-awesome
    ];
    fontconfig = {
      enable = true;
      defaultFonts.monospace = with pkgs; [
        "Hasklig Mono"
      ];
      antialias = true;
      hinting.enable = true;
      hinting.autohint = true;
    };
  };

  home-manager = {
    extraSpecialArgs = with config; {
      inherit inputs;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users."dj" = import ./home;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };

  security.polkit.adminIdentities = [ "unix-user:dj" ];
}
