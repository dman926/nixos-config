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
    sops = {
      age =
        let
          persistHome = "/persist/home/${config.home.username}";
        in
        {
          keyFile = mkDefault "${persistHome}/.config/sops/age/keys.txt";
          generateKey = mkDefault true;
          sshKeyPaths = mkDefault [ "${persistHome}/.ssh/id_ed25519" ];
        };
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
