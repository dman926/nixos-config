{ config, pkgs, ... }:
let
  laptop_lid_switch = pkgs.writeShellScriptBin "laptop_lid_switch" ''
    #!/usr/bin/env bash

    if grep open /proc/acpi/button/lid/LID0/state; then
    		hyprctl keyword monitor "eDP-1, preferred, auto, auto"
    else
    		if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
    				hyprctl keyword monitor "eDP-1, disable"
    		else
    				systemctl suspend
    		fi
    fi
  '';

  resize = pkgs.writeShellScriptBin "resize" ''
    #  Initially inspired by https://github.com/exoess

    # Getting some information about the current window
    # windowinfo=$(hyprctl activewindow) removes the newlines and won't work with grep
    hyprctl activewindow > /tmp/windowinfo
    windowinfo=/tmp/windowinfo

    # Run slurp to get position and size
    if ! slurp=$(slurp); then
    		exit
    fi

    # Parse the output
    pos_x=$(echo $slurp | cut -d " " -f 1 | cut -d , -f 1)
    pos_y=$(echo $slurp | cut -d " " -f 1 | cut -d , -f 2)
    size_x=$(echo $slurp | cut -d " " -f 2 | cut -d x -f 1)
    size_y=$(echo $slurp | cut -d " " -f 2 | cut -d x -f 2)

    # Keep the aspect ratio intact for PiP
    if grep "title: Picture-in-Picture" $windowinfo; then
    		old_size=$(grep "size: " $windowinfo | cut -d " " -f 2)
    		old_size_x=$(echo $old_size | cut -d , -f 1)
    		old_size_y=$(echo $old_size | cut -d , -f 2)

    		size_x=$(((old_size_x * size_y + old_size_y / 2) / old_size_y))
    		echo $old_size_x $old_size_y $size_x $size_y
    fi

    # Resize and move the (now) floating window
    grep "fullscreen: 1" $windowinfo && hyprctl dispatch fullscreen
    grep "floating: 0" $windowinfo && hyprctl dispatch togglefloating
    hyprctl dispatch moveactive exact $pos_x $pos_y
    hyprctl dispatch resizeactive exact $size_x $size_y
  '';
in
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$altMod" = "SUPERALT";
    "$shiftMod" = "SUPERSHIFT";
    "$ctrlMod" = "SUPERCONTROL";
    "$altCtrl" = "ALTCTRL";
    "$shift" = "SHIFT";
    "$alt" = "ALT";
    "$ctrl" = "CONTROL";

    # Programs
    "$fileManager" = "dolphin";
    "$cipboard" = "cliphist list | ${pkgs.rofi-wayland}/bin/rofi -dmenu | cliphist decode | wl-copy";
    "$menu" = "${pkgs.rofi-wayland}/bin/rofi -show drun -mode drun -show-icons";

    bind = [
      "$mainMod, Q, exec, ${config.my.settings.default.terminal}"
      "$mainMod, C, killactive, "
      "$mainMod, M, exec, loginctl terminate-user $USER"
      "$mainMod, M, exit, "
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, togglefloating, "
      "$mainMod, V, exec, $clipboard"
      "$mainMod, R, exec, $menu"
      "$mainMod, P, pseudo, " # dwindle
      "$mainMod, J, togglesplit," # dwindle

      # Multimedia keys
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86MonBrightnessDown, exec, brightnessctl -c backlight s 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl -c backlight s +5%"

      # Screenshot a window, monitor, or region
      "$mainMod, PRINT, exec, hyprshot -m window"
      "$shiftMod, PRINT, exec, hyprshot -m output"
      ", PRINT, exec, hyprshot -m region"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
      "$mainMod ALT, mouse:272, resizewindow"
    ];
  };
}
