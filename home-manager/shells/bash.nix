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
    programs = {
      bash = {
        enable = true;

        bashrcExtra = ''
          [[ -f $HOME/.profile ]] && . $HOME/.profile
        '';

        shellAliases = {
          pnx = "pnpm exec nx";
        };
      };

      direnv.enableBashIntegration = true;
    };
  };
}
