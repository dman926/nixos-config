{ pkgs, ... }:

{
  gtk = {
    enable = true;
    font = {
      name = "Hasklug Nerd Font";
      package = (pkgs.nerdfonts.override { fonts = [ "Hasklig" ]; });
    };
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "Breeze-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style = {
      package = pkgs.libsForQt5.breeze-qt5;
      name = "Breeze";
    };
  };
}
