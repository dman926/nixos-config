{ config, pkgs, lib, ... }:
let
  full-install = config.install-level == "full";
in
{
  imports = [
    ../../programs/scripts
  ];

  config = lib.mkIf full-install {
    script-config.nixos-config-home = "$HOME/Documents/github/nixos-config";

    # For etcher
    nixpkgs.config.permittedInsecurePackages = [
      "electron-19.1.9"
    ];

    environment.systemPackages = with pkgs; [
      qbittorrent
      ffmpeg-full

      vesktop # Discord fork
    ];
  };
}
