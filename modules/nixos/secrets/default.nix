{ inputs, config, ... }:
# Be sure to include `inputs.sops-nix.nixosModules.sops` in config imports
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age = {
    sshKeyPaths = [ "/home/dj/.ssh/id_ed25519" ];
    keyFile = "/home/dj/.config/age/keys.txt";
    generateKey = true;
  };

  sops.secrets = {
    # Copy to my ovpn configs
    "pia/auth-user-pass" = { owner = config.users.users.dj.name; };
  };
}
