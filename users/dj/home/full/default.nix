args@{ osConfig, pkgs, lib, ... }:
let
  full-install = osConfig.install-level == "full";
in
{
  imports =
    let
      # Check is used for imported modules to understand to check the install level
      add_check = f: (import f (args // { check = true; }));
    in
    (map add_check [
      ../../../../modules/home-manager/oh-my-posh
      ../../../../modules/home-manager/vscode-fix
    ]) ++ [
      ./vscode-settings.nix
    ];

  config = lib.mkIf full-install
    {
      home.packages = with pkgs; [
        rnix-lsp

        yubikey-personalization
        sops

        etcher
        blender
        cura
        openscad
        freecad
        rpi-imager

        libreoffice

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
            autoSetupRemote = true;
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
    };
}
