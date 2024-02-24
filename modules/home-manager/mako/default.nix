{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libnotify # Dependency of mako
  ];

  services.mako = with config.colorScheme.palette; {
    enable = true;
    backgroundColor = "#${base01}";
    borderColor = "#${base0E}";
    borderRadius = 5;
    borderSize = 2;
    textColor = "#${base04}";
    layer = "overlay";
  };
}
