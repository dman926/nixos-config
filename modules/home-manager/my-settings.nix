{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.my.settings = {
    default = {
      terminal = mkOption {
        type = types.nullOr (types.enum [ "kitty" ]);
        description = "The default terminal to use";
        default = "kitty";
      };

      browser = mkOption {
        type = types.nullOr (types.enum [ "chromium" "firefox" ]);
        description = "The default browser to use";
        default = null;
      };

      editor = mkOption {
        type = types.nullOr (types.enum [ "nano" "nvim" "code" ]);
        description = "The default editor to use";
        default = "nano";
      };
      shell = mkOption {
        type = types.nullOr (types.enum [ "bash" ]);
        description = "The default shell to use";
        default = "bash";
      };
    };

    impermanenceEnabled = mkOption {
      type = types.bool;
      description = "Whether to enable impermanence to delete home directory on reboot";
      default = false;
    };

    wallpaper = mkOption {
      type = types.str;
      default = "";
      description = ''
        Wallpaper path
      '';
    };

    fonts = {
      regular = mkOption {
        type = types.str;
        description = "The font for regular text";
        default = "Fira Sans";
      };

      monospace = mkOption {
        type = types.str;
        description = "The font for monospace text";
        default = "Hack Nerd Font Mono";
      };
    };

    host = mkOption {
      type = types.str;
      default = "";
      description = ''
        Name of the host
      '';
    };
  };
}
