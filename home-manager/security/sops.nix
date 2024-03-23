{ inputs
, pkgs
, config
, lib
, ...
}:

with lib; let
  cfg = config.modules.sops;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.modules.sops = {
    enable = mkEnableOption "sops";
    sopsFile = mkOption {
      type = lib.types.path;
      default = ../../nixos/users/${config.home.username}/secrets.yaml;
      description = ''
        Sops file used for all secrets.
      '';
    };
  };

  config = mkIf cfg.enable {
      xdg.configFile."sops/age/key.txt".text = "age1g40hqk2mp53rq47ghuamt5hdtwpms0sh4avfjlvgm9efpkfejedqudnype";

      sops = {
        age.keyFile = "/persist/home/${config.home.username}/.config/sops/age/key.txt";
        defaultSymlinkPath = "/run/user/1000/secrets";
        defaultSecretsMountPoint = "/run/user/1000/secrets.d";
        defaultSopsFile = assert (builtins.pathExists cfg.sopsFile); cfg.sopsFile;
      };

      home.packages = with pkgs; [
        sops
      ];

      # Auto restart sops-nix
      home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        /run/current-system/sw/bin/systemctl start --user sops-nix
      '';
    };
}
