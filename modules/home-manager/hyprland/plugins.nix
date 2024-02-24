{ pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
      inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
    ];

    settings = {
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
