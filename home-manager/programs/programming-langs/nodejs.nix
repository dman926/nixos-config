{ pkgs, config, lib, ... }:
let
  valid = builtins.elem "nodejs" config.my.settings.programmingLangs;
  npmGlobalName = ".npm-global";
in
{
  config = lib.mkIf valid {
    home.packages =  [
      pkgs.nodejs_20
    ];

    home.file.".npmrc".text = ''
      prefix=/home/${config.home.username}/${npmGlobalName}
    '';

    programs.bash.bashrcExtra = ''
      # NPM modifications for global packages
      export PATH=$HOME/${npmGlobalName}/bin:$PATH
      export NODE_PATH=$HOME/${npmGlobalName}/lib/node_modules
    '';
  };
}
