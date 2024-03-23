{ config
, pkgs
, ...
}:

{
  config = {
    home.packages = with pkgs; [
      qbittorrent
    ];

    # TODO: settings and theming
  };
}
