{ pkgs, inputs, ... }:
let
  batteryNotify = pkgs.writeShellScriptBin "battery-notify" ''
    # TODO:
    # Hook into /sys/class/power_supply/BAT1/status to get "Discharging"/"Charing" status to dismiss old battery alert.
    # Look into hooking into the power level (or at least upping the poll interval) instead of sleeping for a long time.
    # Look into updating currently present alert instead of just sleeping and issuing a new one.
    
    while true; do
      if [ -f /sys/class/power_supply/BAT1/capacity ]; then
        bat_lvl=$(cat /sys/class/power_supply/BAT1/capacity)
        if [ "$bat_lvl" -le 15 ]; then
          notify-send --urgency=CRITICAL "Battery Low" "Level: ''${bat_lvl}%"
          sleep 360 # 6 minutes between critical alerts
        else
          sleep 120 # 2 minutes between standard checks
        fi
      else
        sleep 360 # 6 minutes between checking for a battery
      fi
    done
  '';

  startupScript =
    let
      hyprland = inputs.hyprland.packages."${pkgs.system}".hyprland;
    in
    pkgs.writeShellScriptBin "hypr-start" ''
      # Active DBus
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      
      # Polkit and Kwallet
      ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &
      exec --no-startup-id ${pkgs.libsForQt5.kwallet-pam}/libexec/pam_kwallet_init
      
      # UI
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
      ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
      ${pkgs.blueman}/bin/blueman-applet &

      # Util
      ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
      ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &
      ${hyprland}/bin/hyprctl setcursor phinger-cursors 1 &      
      ${batteryNotify}/bin/battery-notify &
    '';
in
{
  wayland.windowManager.hyprland.settings.exec-once = ''${startupScript}/bin/hypr-start'';
}
