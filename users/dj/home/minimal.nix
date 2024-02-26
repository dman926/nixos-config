{ config, pkgs, inputs, ... }:
let
  dotkeep = builtins.toFile "keep" "";
  dotnpmrc = builtins.toFile ".npmrc" ''prefix = ''${HOME}/.npm-packages'';
in
{
  imports =
    [
      inputs.hyprland.homeManagerModules.default
      inputs.nix-colors.homeManagerModules.default
      ../../../modules/home-manager/base16-kitty
      ../../../modules/home-manager/hyprland
      ../../../modules/home-manager/mako
      ../../../modules/home-manager/theming
      ../../../modules/home-manager/waybar
    ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;

  programs.home-manager.enable = true;

  home.username = "dj";
  home.homeDirectory = "/home/dj";

  home.packages = with pkgs; [
    # CLI
    bc
    stress
    neofetch
    zip

    # TUI
    btop
    nvitop

    # GUI
    google-chrome
    geeqie
    mpv
    networkmanagerapplet
    # Neither of these are working
    gparted # Doesn't start. Complains there is no DISPLAY when there is
    partition-manager # Starts, but doesn't ask for perms to check disks, so it just hangs at the start

    # Hyprland stuff
    hyprpicker
    phinger-cursors
    rofi-wayland
    # Clipboard
    cliphist
    wl-clipboard
    wl-clipboard-x11
    # Screenshot
    grim
    hyprshot
    # Fix screen share
    xwaylandvideobridge
    # General
    brightnessctl
    playerctl
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

  home.sessionVariables = {
    # XDG User Directories
    XDG_DESKTOP_DIR = config.home.sessionVariables.XDG_DOCUMENTS_DIR;
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    XDG_VIDEOS_DIR = "$HOME/Videos";
    # General
    EDITOR = "nano";
    GPG_TTY = "$(tty)";
    HYPRSHOT_DIR = "${config.home.sessionVariables.XDG_PICTURES_DIR}/Screenshots";
  };

  home.file = {
    # TODO: dotfiles
    "Documents/.keep".source = dotkeep;
    "Downloads/.keep".source = dotkeep;
    ".npmrc".source = dotnpmrc;
    # Cursor
    ".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
  };

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    desktopEntries = {
      google-chrome-incognito = {
        name = "Google Chrome - Incognito";
        genericName = "Web Browser";
        comment = "Access the Internet in Incognito";
        exec = "${pkgs.google-chrome}/bin/google-chrome-stable --incognito %U";
        startupNotify = true;
        terminal = false;
        icon = "google-chrome";
        categories = [ "Network" "WebBrowser" ];
      };
      hydroxide-share = {
        name = "Hydroxide share";
        genericName = "File Manager";
        comment = "Access the Hydroxide share";
        exec = "${pkgs.xfce.thunar}/bin/thunar smb://192.168.50.201";
        terminal = false;
        icon = "thunar";
        categories = [ "System" "Core" "GTK" "FileTools" "FileManager" ];
      };
    };
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [
        inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
    };
  };

  programs.bash.enable = true;

  programs.kitty = {
    enable = true;
    base16-theme = "standard";
  };

  # TODO: get and style tmux
  # programs.tmux = {
  #   enable = true;
  #   clock24 = true;
  #   mouse = true;
  # };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    userSettings = {
      # fix to get vscode to run on wayland
      "window.titleBarStyle" = "custom";
      # Shut up update notification
      "update.mode" = "none";
    };
  };

  programs.neovim = {
    enable = true;
    # TODO: config
  };
}
