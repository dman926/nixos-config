{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.hyprland.homeManagerModules.default
      ../../modules/home-manager/hyprland
    ];

  programs.home-manager.enable = true;

  home.username = "dj";
  home.homeDirectory = "/home/dj";

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hasklig" ]; })

    xdg-utils
    pinentry
    btop
    stress

    yubikey-personalization
  ];

  home.sessionVariables = {
    EDITOR = "nano";
    GPG_TTY = "$(tty)";
    # XDG Base Directories
    XDG_DATA_DIRS = "/usr/local/share:/usr/share";
    XDG_CONFIG_DIRS = "/etc/xdg";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_DATE_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_RUNTIME_DIR = "/run/user/$UID";
  };

  home.file = {
    # TODO: dotfiles
  };

  xdg = {
    enable = true;
    mimeApps.defaultApplications = {

    };
  };

  programs.git = {
    enable = true;
    userName = "dman926";
    userEmail = "dj@dstelmach.com";
    aliases = {
      gone = "!f() { git fetch --all --prune; git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    # fix to get vscode to run on wayland
    userSettings = { "window.titleBarStyle" = "custom"; };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
