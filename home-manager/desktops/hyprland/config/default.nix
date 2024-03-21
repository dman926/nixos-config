{ inputs
, pkgs
, config
, ...
}:

{
  imports = [
    ./keybindings.nix
    # TODO: windowrules aren't configured correctly
    # ./windowrules.nix
    ./window-rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = config.modules.wms.hyprland.enable;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      input = {
        kb_layout = "us";
        touchpad = {
          disable_while_typing = false;
        };
      };

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 3;
        "col.active_border" = "0xff${config.colorScheme.palette.base07}";
        "col.inactive_border" = "0xff${config.colorScheme.palette.base02}";
      };

      decoration = {
        rounding = 5;
      };

      misc =
        let
          FULLSCREEN_ONLY = 2;
        in
        {
          vrr = 2;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          # variable_framerate = true;
          # variable_refresh = FULLSCREEN_ONLY;
          disable_autoreload = true;
        };

      env = [
        "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
        "NIXOS_OZONE_WL,1"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.swaynotificationcenter}/bin/swaync"
        "${pkgs.kanshi}/bin/kanshi"
        "${inputs.waybar.packages."${pkgs.system}".waybar}/bin/waybar"
        "${pkgs.gammastep}/bin/gammastep"
        "${pkgs.swaybg}/bin/swaybg -i ${config.my.settings.wallpaper} --mode fill"
        "${pkgs.trayscale}/bin/trayscale --hide-window"
        # TODO: My startup packages
        # "mullvad-gui"
        # "solaar -w hide"
        "blueman-applet"
      ];
    };
  };
}
