{ config, inputs, pkgs, lib, full-install, ... }:
let
  dotkeep = builtins.toFile "keep" "";
  dotnpmrc = builtins.toFile ".npmrc" ''prefix = ''${HOME}/.npm-packages'';
in
{
  imports =
    [
      inputs.hyprland.homeManagerModules.default
      ../../modules/home-manager/hyprland
      ../../modules/home-manager/oh-my-posh
      ../../modules/home-manager/vscode-fix
      ../../modules/home-manager/waybar
    ];

  config = lib.mkMerge [
    # Full Install
    (lib.mkIf full-install {
      home.packages = with pkgs; [
        yubikey-personalization
        sops

        etcher
        blender
        cura
        openscad
        freecad

        # Programming
        # These really should be in a shell.nix,
        # but I don't like the idea making a bunch of them    
        nodejs_20
        go
        # Python/PDM: See WORKSPACE/programs/dev-env/pdm-shell.nix
      ];

      programs.bash = {
        bashrcExtra = ''
          [[ -f $HOME/.profile ]] && . $HOME/.profile

          # NPM modifications for global packages
          export PATH=$HOME/.npm-packages/bin:$PATH
          export NODE_PATH=$HOME/.npm-packages/lib/node_modules

          # Go modifications for global packages
          export GOPATH=$HOME/.go
          export GO111MODULE=auto
          export PATH=$GOPATH/bin:$PATH
        '';
        shellAliases = {
          pnx = "pnpm exec nx";
        };
      };

      programs.git = {
        enable = true;
        userName = "dman926";
        userEmail = "dj@dstelmach.com";
        signing = {
          key = "3157A0E73E7310AE7DD11A58E1A18DF6B4F919E4";
          signByDefault = true;
        };
        lfs.enable = true;
        aliases = {
          gone = "!f() { git fetch --all --prune; git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f";
        };
        extraConfig = {
          push = {
            autoSetupRemove = true;
          };
          pull = {
            rebase = true;
          };
          fetch = {
            prune = true;
          };
          init = {
            defaultBranch = "main";
          };
        };
      };

      programs.vscode.userSettings = {
        "workbench.startupEditor" = "none";
        "editor.fontFamily" = "'Hasklug Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.tabSize" = 2;
        "cmake.showOptionsMovedNotification" = false;
        "cmake.configureOnOpen" = true;
        # Language defaults
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    })

    # Base
    {
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

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.11"; # Please read the comment before changing.
    }
  ];
}
