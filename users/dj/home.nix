{ config, pkgs, inputs, ... }:
let
  dotkeep = builtins.toFile "keep" "";
  dotnpmrc = builtins.toFile ".npmrc" ''prefix = ''${HOME}/.npm-packages'';
  oh-my-posh-themes =
    let
      resources = pkgs.fetchFromGitHub {
        owner = "JanDeDobbeleer";
        repo = "oh-my-posh";
        rev = "v19.8.3";
        hash = "sha256-sYXg/t8U+uu1kYtEH6j7s/dCQJGuG880ruQFrvB5GS8="; # pkgs.lib.fakeHash;
      };
      theme_names =
        (builtins.filter (name: !(isNull (builtins.match ".+omp.json$" name)))
          (builtins.attrNames (builtins.readDir "${resources}/themes")));
      make_theme = (name: {
        name = ".config/oh-my-posh-themes/${name}";
        value = {
          source = "${resources}/themes/${name}";
        };
      });
    in
    builtins.listToAttrs (map make_theme theme_names);
in
{
  imports =
    [
      inputs.hyprland.homeManagerModules.default
      ../../modules/home-manager/hyprland
      ../../modules/home-manager/vscode-fix
      ../../modules/home-manager/waybar
    ];

  programs.home-manager.enable = true;

  home.username = "dj";
  home.homeDirectory = "/home/dj";

  home.packages = with pkgs; [
    networkmanagerapplet
    xdg-utils
    pinentry-rofi
    btop
    nvitop
    stress
    neofetch

    yubikey-personalization
    sops

    phinger-cursors

    google-chrome
    geeqie
    mpv
    oh-my-posh
    blender
    cura
    openscad
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

    # Programming
    # These really should be in a shell.nix,
    # but I don't like the idea making a bunch of them    
    nodejs_20
    go
    # Python/PDM: See WORKSPACE/programs/dev-env/pdm-shell.nix
  ];

  home.sessionVariables = {
    # XDG User Directories
    XDG_DESKTOP_DIR = "$HOME/Desktop";
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
  } // oh-my-posh-themes;

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    # mimeApps.defaultApplications = { };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      [[ -f $HOME/.profile ]] && . $HOME/.profile

      [[ -f $HOME/.config/oh-my-posh-themes/night-owl.omp.json ]] && eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init bash --config $HOME/.config/oh-my-posh-themes/night-owl.omp.json)"

      # NPM modifications for global packages
      export PATH=$HOME/.npm-packages/bin:$PATH
      export NODE_PATH=$HOME/.npm-packages/lib/node_modules

      # Go modifications for global packages
      export GOPATH=$HOME/.go
      export GO111MODULE=auto
      export PATH=$GOPATH/bin:$PATH
    '';
  };

  programs.git = {
    enable = true;
    userName = "dman926";
    userEmail = "dj@dstelmach.com";
    signing = {
      key = "3157A0E73E7310AE7DD11A58E1A18DF6B4F919E4";
      signByDefault = true;
    };
    aliases = {
      gone = "!f() { git fetch --all --prune; git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f";
    };
    extraConfig = {
      push = {
        autoSetupRemove = true;
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    # fix to get vscode to run on wayland
    userSettings = { "window.titleBarStyle" = "custom"; };
  };

  programs.neovim = {
    enable = true;
    # TODO: config
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
