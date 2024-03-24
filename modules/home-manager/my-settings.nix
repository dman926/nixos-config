{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.my.settings = {
    default = {
      terminal = mkOption {
        type = with types; nullOr (enum [ "kitty" ]);
        description = "The default terminal to use";
        default = "kitty";
      };

      browser = mkOption {
        type = with types; nullOr (enum [ "chromium" "google-chrome" "firefox" ]);
        description = "The default browser to use";
        default = null;
      };

      editor = mkOption {
        type = with types; nullOr (enum [ "nano" "nvim" "code" ]);
        description = "The default editor to use";
        default = "nano";
      };
      shell = mkOption {
        type = with types; nullOr (enum [ "bash" ]);
        description = "The default shell to use";
        default = "bash";
      };
    };

    # TODO: Integrate wallpaper
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

    programmingLangs = mkOption
      {
        type = with types; listOf (enum [
          "nodejs"
          "go"
        ]);
        default = [ ];
        description = ''
          List of programming languages to install
        '';
      };
  };
}
