{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age = {
      keyFile = "/persist/system/var/lib/sops-nix/key.txt";
      # generateKey = true;
      sshKeyPaths = [ "/persist/system/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
