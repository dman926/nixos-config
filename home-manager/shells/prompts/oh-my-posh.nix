{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.modules.shells.prompts.oh-my-posh;

  resources = pkgs.oh-my-posh.src;

  theme_names =
    let
      themes = builtins.readDir "${resources}/themes";
      map_attrs_to_theme_name = name: value: if value == "regular" then (builtins.match "(.+)\.omp\.json$" name) else null;
      base_themes = builtins.attrValues (builtins.mapAttrs map_attrs_to_theme_name themes);
    in
    lists.flatten (builtins.filter (name: !(builtins.isNull name)) base_themes);

  theme_path = theme: { xdg.configFile."oh-my-posh-themes/${theme}.omp.json" .source = "${resources}/themes/${theme}.omp.json"; };

  # This really only supports bash right now
  make_entrypoint = shell:
    let
      themePath = "$HOME/.config/oh-my-posh-themes/${cfg.theme}.omp.json";
      make_entry = additional: ''eval "${pkgs.oh-my-posh}/bin/oh-my-posh init ${shell}'' + (mkIf (additional != null) " ${additional}") + ''"'';
    in
    if (cfg.theme != null) then
      concatStringsSep " " [
        "[[ -f ${themePath} ]] &&"
        make_entry
        "--config ${themePath})"
      ] else make_entry null;
in
{
  options.modules.shells.prompts.oh-my-posh =
    {
      enable = mkEnableOption "oh-my-posh prompt";

      shells = mkOption {
        type = with types; nullOr (listOf (enum [ "bash" ]));
        default = [ "bash" ];
        description = "shells to enable oh-my-posh in";
      };

      theme = mkOption {
        type = with types; nullOr (listOf (enum theme_names));
        default = "night-owl-abc";
        description = "oh-my-posh theme";
      };
    };

  config = mkIf cfg.enable
    {
      home.packages = with pkgs;
        [
          oh-my-posh
        ];
      programs.bash.bashrcExtra = mkIf (builtins.elem "bash" cfg.shells) (make_entrypoint "bash");
    } // (theme_path cfg.theme);
  #   } // (mkIf (cfg.enable && cfg.theme != null) ({
  # } // (theme_path cfg.theme)));
}
