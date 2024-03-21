{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  # TODO: update CSS to interpolate colors
  xdg.configFile."swaync/style.css".source = ./swaync.css;
  xdg.configFile."swaync/config.json".source = ./swaync.json;
}
