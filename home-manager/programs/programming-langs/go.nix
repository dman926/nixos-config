{ pkgs, config, lib, ... }:
let
  valid = builtins.elem "go" config.my.settings.programmingLangs;
in
{
  config = lib.mkIf valid {
    home.packages = [
      pkgs.go
    ];

    programs.bash.bashrcExtra = ''
      # Go modifications for global packages
      export GOPATH=$HOME/.go
      export GO111MODULE=auto
      export PATH=$GOPATH/bin:$PATH
    '';
  };
}
