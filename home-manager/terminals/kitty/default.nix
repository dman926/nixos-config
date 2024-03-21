{ config
, lib
, ...
}:
with lib; let
  cfg = config.modules.terminals.kitty;
in
# Adapted from https://github.com/kdrag0n/base16-kitty templates
{
  imports = [
    ./standard.nix
    ./256-color.nix
  ];

  options.modules.terminals.kitty = {
    enable = mkEnableOption "kitty terminal emulator";
    base16-theme = mkOption {
      description = ''What Base16 theming option should be used for kitty?
        `null` produces no Base16 theming.
        
        "standard" maps main items and the first 16 colors (8 normal, 8 bright).

        "256" maps main items, the first 16 colors (8 normal, 8 bright), and sets the next brightest colors to direct Base16 colors to avoid interpolation issues.

        You should try using "standard" first and switch to "256" if colors look strange or very dark.
        '';
      example = ''"standard"'';
      type = with types; nullOr (uniq (enum [ "standard" "256" ]));
      default = null;
    };
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = config.my.settings.fonts.monospace;
        size = 14;
      };
    };
  };
}
