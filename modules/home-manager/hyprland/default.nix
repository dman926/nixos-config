{ inputs, pkgs, lib, hostName, use-nvidia, ... }:
let
  batteryNotify = pkgs.pkgs.writeShellScriptBin "battery-notify" ''
    while true; do
      bat_lvl=$(cat /sys/class/power_supply/BAT1/capacity)
      if [ "$bat_lvl" -le 15 ]; then
        notify-send --urgency=CRITICAL "Battery Low" "Level: ''${bat_lvl}%"
        sleep 360 # 6 minutes between critical alerts
      else
        sleep 120 # 2 minutes between standard checks
      fi
    done
  '';
  startupScript =
    let
      hyprland = inputs.hyprland.packages."${pkgs.system}".hyprland;
    in
    pkgs.pkgs.writeShellScriptBin "start" ''
      # Fix portal issues
      systemctl --user import-environment PATH && \
      systemctl --user restart xdg-desktop-portal.service &

      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
      ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
      ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
      ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &
      ${batteryNotify}/bin/battery-notify &
      ${hyprland}/bin/hyprctl setcursor phinger-cursors 1 &
    '';
  monitorMap = {
    electron = "eDP-1,preferred,auto,1.33";
    neutron = "eDP-1,preferred,auto,1.33";
    hydrogen = [
      "DP-3,highres,0x0,1"
      "HDMI-A-1,highres,-2560x0,1"
    ];
    default = ",preferred,auto,auto";
  };
  env = lib.mkMerge [
    (lib.mkIf use-nvidia [
      "LIBVA_DRIVERNAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GDM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "WLR_NO_HARDWARE_CURSORS,1"
    ])
    [
      "XCURSOR_SIZE,24"
      "QT_QPA_PLATFORMTHEME,qt5ct"
    ]
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
      inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
    ];

    # Enable session
    systemd = {
      enable = true;
      variables = [ "-all" ];
    };

    settings = {
      "$mainMod" = "SUPER";
      "$shiftMod" = "SUPERSHIFT";

      # Programs
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$cipboard" = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
      "$menu" = "rofi -show drun";

      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive, "
        "$mainMod, M, exec, loginctl terminate-user $USER"
        "$mainMod, M, exit, "
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating, "
        "$mainMod, V, exec, $clipboard"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo, " # dwindle
        "$mainMod, J, togglesplit," # dwindle

        # Multimedia keys
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86MonBrightnessDown, exec, brightnessctl -c backlight s 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl -c backlight s +5%"

        # Screenshot a window, monitor, or region
        "$mainMod, PRINT, exec, hyprshot -m window"
        "$shiftMod, PRINT, exec, hyprshot -m output"
        ", PRINT, exec, hyprshot -m region"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod ALT, mouse:272, resizewindow"
      ];

      exec-once = ''${startupScript}/bin/start'';

      monitor =
        if builtins.hasAttr hostName monitorMap
        then monitorMap."${hostName}"
        else monitorMap.default;

      inherit env;

      misc = {
        force_default_wallpaper = 0; # Turn off default anime
      };

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

        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        cursor_inactive_timeout = 60;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
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

      windowrulev2 = [
        "nomaximizerequest, class:.*" # You'll probably like this.
        "float, class: (xdg-desktop-portal-gtk)"
        "float, class: (thunar) title: ^(File Operation Progress)$"
        "float, class: (thunar) title: ^(Confirm to replace files)$"
        "float, class: (org.qbittorrent.qBittorrent), title: ^(?!qBittorrent).*$"

        # xwaylandvideobridge workaround
        # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];

      # Plugins
      "plugin:borders-plus-plus" = {
        add_borders = 1; # 0 - 9

        "col.border_1" = "rbg(ffffff)";
        "col.border_2" = "rbg(2222ff)";

        border_size_1 = 10;
        border_size_2 = -1;

        natural_rounding = true;
      };

      "plugin:hyprbars" = {
        bar_height = 20;

        hyprbars-button = [
          "rgb(ff4040), 10, hyprctl dispatch killactive"
          "rgb(eeee11), 10, hyprctl dispatch fullscreen 1"
        ];
      };
    };
  };
}
