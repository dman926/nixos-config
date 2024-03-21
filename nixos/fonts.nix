{ pkgs, ... }:

{
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hasklig" "Meslo" "Hack" ]; })
      fira
      fira-go
      joypixels
      liberation_ttf
      source-serif
      ubuntu_font_family
      work-sans
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      oxygenfonts
      cantarell-fonts
      open-sans
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = [ "Source Serif" ];
        sansSerif = [ "Work Sans" "Fira Sans" "FiraGO" ];
        monospace = [ "Hack Nerd Font Mono" "DejaVu Sans Mono" ];
        emoji = [ "Joypixels" "Noto Color Emoji" ];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };
}
