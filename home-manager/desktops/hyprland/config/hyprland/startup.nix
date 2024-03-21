{ osConfig, pkgs, inputs, ... }:
let
  # TODO:
  # Hook into /sys/class/power_supply/BAT1/status to get "Discharging"/"Charing" status to dismiss old battery alert.
  # Look into hooking into the power level (or at least upping the poll interval) instead of sleeping for a long time.
  # Look into updating currently present alert instead of just sleeping and issuing a new one.
  battery_notify = pkgs.writeShellScriptBin "battery_notify" ''
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
  laptop_lid_switch = pkgs.writeShellScriptBin "laptop_lid_switch" ''
    #!/usr/bin/env bash

    if grep open /proc/acpi/button/lid/LID0/state; then
        hyprctl keyword monitor "eDP-1, 2256x1504@60, 0x0, 1"
    else
        if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
            hyprctl keyword monitor "eDP-1, disable"
        fi
    fi
  '';
  swww_randomizer = pkgs.writeShellScriptBin "swww_randomiser" ''
  
  '';

  startupScript =
    let
      hyprland = inputs.hyprland.packages."${pkgs.system}".hyprland;
      blueman = if osConfig.services.blueman.enable then "${pkgs.blueman}/bin/blueman-applet &" else "";
    in
    pkgs.writeShellScriptBin "hypr-start" ''
      # Session
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH &
      systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH &

      # Fix portal
      systemctl --user import-environment PATH && \
      systemctl --user restart xdg-desktop-portal.service &

      # Polkit
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      
      # UI
      ${inputs.waybar.packages."${pkgs.system}".waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
      ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
      ${blueman}
      ${pkgs.kanshi}/bin/kanshi &

      # Util
      ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
      ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &
      ${hyprland}/bin/hyprctl setcursor phinger-cursors 1 &
      ${battery_notify}/bin/battery_notify &
      ${laptop_lid_switch}/bin/laptop_lid_switch &
    '';
in
{
  wayland.windowManager.hyprland.settings.exec-once = ''${startupScript}/bin/hypr-start'';
}
