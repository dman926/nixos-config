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
      ../../../modules/home-manager/hyprland
      ../../../modules/home-manager/mako
      ../../../modules/home-manager/waybar
    ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;

  programs.home-manager.enable = true;

  home.username = "dj";
  home.homeDirectory = "/home/dj";

  home.packages = with pkgs; [
    networkmanagerapplet
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    pinentry-rofi
    btop
    nvitop
    stress
    neofetch
    bc

    phinger-cursors

    google-chrome
    geeqie
    mpv
    hyprpicker
    # Clipboard
    cliphist
    wl-clipboard
    wl-clipboard-x11
    # Screenshot
    grim
    hyprshot
    # Fix screen share
    xwaylandvideobridge

    brightnessctl
    playerctl
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    # fix to get vscode to run on wayland
    userSettings."window.titleBarStyle" = "custom";
  };

  programs.neovim = {
    enable = true;
    # TODO: config
  };
}
