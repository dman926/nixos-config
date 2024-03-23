{ outputs
, lib
, ...
}:
let
  hostnames = builtins.attrNames outputs.nixosConfigurations;
in
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      net = {
        host = builtins.concatStringsSep " " hostnames;
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = ''/%d/.gnupg-sockets/S.gpg-agent'';
            host.address = ''/%d/.gnupg-sockets/S.gpg-agent.extra'';
          }
        ];
      };
      # TODO: figure out what trusted.host is
      trusted = lib.hm.dag.entryBefore [ "net" ] {
        host = "m7.rs *.m7.rs *.ts.m7.rs";
        forwardAgent = true;
      };
    };
  };
}
