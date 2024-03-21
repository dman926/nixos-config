{ inputs
, lib
, config
, ...
}:

{
  imports = [
    ../.
    # Likely will be moved to home-manager/programs/default.nix
    # and controlled with config
    # ../programs/gaming.nix
  ];

  config = with lib; {
    modules = {
      browsers = {
        chromium.enable = mkDefault true;
      };

      shells = {
        bash.enable = mkDefault true;
      };

      wms = {
        hyprland.enable = mkDefault true;
      };

      terminals = {
        kitty.enable = mkDefault true;
      };
    };

    my.settings = {
      default = {
        terminal = mkDefault "kitty";
        browser = mkDefault "chromium";
        editor = mkDefault "nano";
      };
    };

    colorscheme = mkDefault inputs.nix-colors.colorSchemes.tokyo-night-dark;

    home = {
      username = mkDefault "dj";
      homeDirectory = mkDefault "/home/${config.home.username}";
      stateVersion = mkDefault "23.11";
    };
  };
}
