{ inputs
, pkgs
, lib
, config
, ...
}:

with lib; {
  imports = [
    ../home-manager
    # ../home-manager/programs/gaming.nix
  ];

  config = {
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
      host = mkDefault "electron";
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
