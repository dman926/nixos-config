{ ... }:

{
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "nomaximizerequest, class:.*" # You'll probably like this.
    "float, class: (xdg-desktop-portal-gtk)"
    "float, class: (org.kde.polkit-kde-authentication-agent-1)"
    "float, class: (thunar) title: ^(File Operation Progress)$"
    "float, class: (thunar) title: ^(Confirm to replace files)$"
    "float, class: (org.qbittorrent.qBittorrent), title: ^(?!qBittorrent).*$"

    # xwaylandvideobridge workaround
    # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"
  ];
}
