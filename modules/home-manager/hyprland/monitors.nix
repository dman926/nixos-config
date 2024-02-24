{ osConfig, ... }:
let
  monitorMap = {
    electron = "eDP-1,preferred,auto,1.33";
    neutron = "eDP-1,preferred,auto,1.33";
    hydrogen = [
      "DP-3,highres,0x0,1"
      "HDMI-A-1,highres,-2560x0,1"
    ];
    default = ",preferred,auto,auto";
  };
in
{
  wayland.windowManager.hyprland.settings.monitor =
    if builtins.hasAttr osConfig.networking.hostName monitorMap
    then monitorMap."${osConfig.networking.hostName}"
    else monitorMap.default;
}
