{ config, inputs, pkgs, ... }:

{
  users.groups.dj = {};

  users.users.dj = {
    isNormalUser = true;
    description = "DJ Stelmach";
    group = "dj";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    # openssh.authorizedKeys.keys = [ TODO: ed25519 and rsa keys ];

    # TODO move to home manager
    packages = with pkgs; [
      google-chrome
      mpv
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hasklig" ]; })
      font-awesome
    ];
    fontconfig = {
      enable = true;
      defaultFonts.monospace = with pkgs; [
        "Hasklig Mono"
      ];
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      # Machine identification for fine-tuning
      hostName = "${config.networking.hostName}";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users."dj" = import ./home.nix;
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
}