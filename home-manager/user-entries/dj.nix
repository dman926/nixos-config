{ lib
, ...
}:

{
  imports = [
    ./default.nix
  ];

  config = with lib; {
    modules = {
      browsers = {
        chromium.enable = mkDefault true;
      };

      editors = {
        code.enable = mkDefault true;
        # nvim.enable = mkDefault true;
      };

      multiplexers = {
        tmux.enable = mkDefault true;
      };

      shells = {
        bash.enable = mkDefault true;
      };

      wms = {
        hyprland.enable = mkDefault true;
      };

      terminals = {
        kitty.enable = mkDefault true;
        warp.enable = mkDefault true;
      };
    };

    my.settings = {
      #wallpaper = mkDefault "~/dotfiles/home-manager/wallpapers/Kurzgesagt-Galaxy_3.png";
      default = {
        terminal = mkDefault "kitty";
        browser = mkDefault "chromium";
        editor = mkDefault "nano";
      };
    };

    home.username = "dj";
  };
}
