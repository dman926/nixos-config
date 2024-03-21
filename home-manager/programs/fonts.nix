{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    fontconfig
    (nerdfonts.override { fonts = [ "Hasklig" "Meslo" "Hack" ]; })
    noto-fonts-color-emoji
    google-fonts
    twitter-color-emoji
    open-sans
    zlib # workaround for #703
  ];

  fonts.fontconfig.enable = lib.mkForce true;
}
