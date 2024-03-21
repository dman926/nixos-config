{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.shells.bash;
in
{
  options.modules.shells.bash = {
    enable = mkEnableOption "bash shell";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.comma pkgs.gum ];
    programs.bash = {
      enable = true;

      bashrcExtra = concatLines [
        "[[ -f $HOME/.profile ]] && . $HOME/.profile"

        # NPM modifications for global packages
        "export PATH=$HOME/.npm-packages/bin:$PATH"
        "export NODE_PATH=$HOME/.npm-packages/lib/node_modules"

        # Go modifications for global packages
        "export GOPATH=$HOME/.go"
        "export GO111MODULE=auto"
        "export PATH=$GOPATH/bin:$PATH"
      ];

      shellAliases = {
        pnx = "pnpm exec nx";
      };
    };
  };
}
