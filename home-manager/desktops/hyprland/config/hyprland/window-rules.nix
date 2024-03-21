{
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    # Control Rules

    # Don't allow a window to maximize itself
    # "nomaximizerequest, class:.*"
  ] ++ [
    # Tile rules
    "tile, class: (Thunar) title: ^(File Manager Preferences)$"

    # Float rules

    "float, class: (xdg-desktop-portal-gtk)"
    "float, class: (org.kde.polkit-kde-authentication-agent-1)"
    "float, class: (thunar) title: ^(File Operation Progress)$"
    "float, class: (thunar) title: ^(Confirm to replace files)$"

    # Float non-main application windows
    "float, class: (org.qbittorrent.qBittorrent), title: ^(?!qBittorrent).*$"
    "float, class: (com/.https://ultimaker.python3), title: ^(?!Ultimaker Cura).*$"
  ] ++ [
    # xwaylandvideobridge workaround
    # https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/#xwayland
    "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"
  ];
}
