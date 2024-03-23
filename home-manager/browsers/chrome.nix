{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.chrome;
in
{
  options.modules.browsers.chrome = {
    enable = mkEnableOption "google chrome browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
    ];

    home.persistence."/persist/home/${config.home.username}".directories = [
      ".config/google-chrome"
    ];
  };
}
