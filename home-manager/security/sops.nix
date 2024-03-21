{ inputs
, pkgs
, config
, ...
}:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  xdg.configFile."sops/age/key.txt".text = "age1g40hqk2mp53rq47ghuamt5hdtwpms0sh4avfjlvgm9efpkfejedqudnype";

  sops = {
    age.keyFile = "/persist/home/${config.home.username}/.config/sops/age/key.txt";
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  home.packages = with pkgs; [
    sops
  ];

  # Auto restart sops-nix
  # home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #   /run/current-system/sw/bin/systemctl start --user sops-nix
  # '';
}
