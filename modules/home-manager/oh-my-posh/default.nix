{ osConfig, pkgs, lib, check ? false, ... }:
let
  theme = "night-owl";

  oh-my-posh-themes =
    let
      resources = pkgs.fetchFromGitHub {
        owner = "JanDeDobbeleer";
        repo = "oh-my-posh";
        rev = "v19.8.3";
        hash = "sha256-sYXg/t8U+uu1kYtEH6j7s/dCQJGuG880ruQFrvB5GS8=";
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

  oh-my-posh-entrypoint = ''[[ -f $HOME/.config/oh-my-posh-themes/${theme}.omp.json ]] && eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init bash --config $HOME/.config/oh-my-posh-themes/${theme}.omp.json)"
  '';

  valid = !check || osConfig.install-level == "full";
in
lib.mkIf valid {
  home.packages = with pkgs; [
    oh-my-posh
  ];

  home.file = oh-my-posh-themes;

  programs.bash.bashrcExtra = oh-my-posh-entrypoint;
}
