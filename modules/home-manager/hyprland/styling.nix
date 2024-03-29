{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = with config.colorScheme.palette; {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
      "col.inactive_border" = "rgba(${base00}D9)";
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
  };
}
