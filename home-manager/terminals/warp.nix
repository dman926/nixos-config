{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.modules.terminals.warp;
in
{
  options.modules.terminals.warp = {
    enable = mkEnableOption "warp terminal emulator";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.warp-terminal
    ];
  };
}
