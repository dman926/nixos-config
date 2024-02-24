{ osConfig, lib, ... }:
let
  env = lib.mkMerge [
    (lib.mkIf osConfig.hardware.nvidia.modesetting.enable [
      "LIBVA_DRIVERNAME,nvidia"
      "GDM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "WLR_NO_HARDWARE_CURSORS,1"
    ])
    [
      "XCURSOR_SIZE,24"
      "XDG_SESSION_TYPE,wayland"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_QPA_PLATFORM,wayland"
      "QT_QPA_PLATFORMTHEME,qt5ct"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    ]
  ];
in
{
  imports = [
    ./binds.nix
    ./monitors.nix
    ./plugins.nix
    ./startup.nix
    ./styling.nix
    ./window-rules.nix
  ];

  # Tell other applications to use dark mode
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      inherit env;

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        layout = "dwindle";

        cursor_inactive_timeout = 60;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      "device:epic-mouse-v1" = {
        sensitivity = -0.5;
      };

      misc.force_default_wallpaper = 0; # Turn off default anime wallpaper
    };
  };
}
