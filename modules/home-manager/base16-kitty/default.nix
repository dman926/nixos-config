{ lib, ... }:
# Adapted from https://github.com/kdrag0n/base16-kitty templates
{
  imports = [
    ./standard.nix
    ./256-color.nix
  ];

  options.programs.kitty.base16-theme = with lib; mkOption {
    description = ''What Base16 theming option should be used for kitty?
    `null` produces no Base16 theming.'';
    example = ''"standard"'';
    type = with types; nullOr (uniq (enum [ "standard" "256" ]));
  };
}
