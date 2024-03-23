# This file defines overlays
{ inputs, ... }:

{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # Temp fix for fprintd failing meson checks
    # https://github.com/NixOS/nixpkgs/issues/298150#issuecomment-2015815945
    fprintd = prev.fprintd.overrideAttrs (_: {
      mesonCheckFlags = [
        "--no-suite"
        "fprintd:TestPamFprintd"
      ];
    });
  };
}
