{ config, lib, pkgs, ... }:
let
  nix-rebuild = import ./nix-rebuild {
    inherit pkgs;
    config-home = config.script-config.nixos-config-home;
  };

  media-processor = lib.mkIf config.script-config.media-processor.enable [
    (import ./media-processor {
      inherit pkgs;
      work-dir = config.script-config.media-processor.work-dir;
    })
  ];
in
{
  environment.systemPackages = lib.mkMerge [
    media-processor

    [ nix-rebuild ]
  ];
}
