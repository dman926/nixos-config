{ pkgs, inputs, ... }:
let
  batteryNotify = pkgs.writeShellScriptBin "battery-notify" ''
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
      # Fix portal issues
      systemctl --user import-environment PATH && \
      systemctl --user restart xdg-desktop-portal.service &

      # Polkit and Keychain
      ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &
      ${pkgs.kwallet-pam}/libexec/pam_kwallet_init &

      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
      ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
      ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
      ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &
      ${batteryNotify}/bin/battery-notify &
      ${hyprland}/bin/hyprctl setcursor phinger-cursors 1 &
    '';
in
{
  wayland.windowManager.hyprland.settings.exec-once = ''${startupScript}/bin/hypr-start'';
}
