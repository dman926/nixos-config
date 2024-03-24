{ pkgs
, config
, inputs
, lib
, ...
}:
with lib; let
  cfg = config.modules.wms.hyprland;
in
{
  imports = [
    ./config/hyprland
    ./gammastep.nix
    ./kanshi.nix
    ./rofi.nix
    ./swaync
    ./swaylock.nix
    ./theme
    ./waybar
    ./wlogout
    ./xdg.nix

    ../../programs/gui.nix

    inputs.hyprland.homeManagerModules.default
  ];

  options.modules.wms.hyprland = {
    enable = mkEnableOption "hyprland window manager";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      LIBSEAT_BACKEND = "logind";
    };

    dconf.settings = {
      "org/gnome/desktop/privacy" = {
        remember-recent-files = false;
      };
    };

    home.packages = with pkgs; [
      # TODO: Review packages
      mplayer
      mtpfs
      jmtpfs
      brightnessctl
      xdg-utils
      wl-clipboard
      pamixer
      playerctl

      inputs.nwg-displays.packages.${pkgs.system}.default
      grimblast
      slurp
      sway-contrib.grimshot
      satty
    ];

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}