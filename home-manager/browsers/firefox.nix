{ lib
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.firefox;
in
{
  options.modules.browsers.firefox = {
    enable = mkEnableOption "firefox browser";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      # TODO
    };
  };
}
