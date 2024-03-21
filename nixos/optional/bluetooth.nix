{ config
, lib
, ...
}:
with lib; let
  cfg = config.modules.nixos.bluetooth;
in
{
  options.modules.nixos.bluetooth = {
    enable = mkEnableOption "bluetooth service and packages";
  };

  config = mkIf cfg.enable {
    services.blueman.enable = true;
    hardware.bluetooth = {
      powerOnBoot = false;
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
}
