{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
    ];

    settings = {
      "plugin:borders-plus-plus" = with config.colorScheme.palette; {
        add_borders = 1; # 0 - 9

        "col.border_1" = "rgb(${base02})";

        border_size_1 = 1;

        natural_rounding = true;
      };
    };
  };
}
