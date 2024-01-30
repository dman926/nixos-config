{ .. }:
# Be sure to include `inputs.sops-nix.nixosModules.sops` in config imports
{
  sops.defaultSopsFile = ../../../secrets/secrets.yml;
  sops.defaultSopsFormat = "yaml";

  sops.secrets = {
    "" = { owner = "dj"; };
  };
}