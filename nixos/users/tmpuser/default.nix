{ config
, pkgs
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  home-manager.users.tmpuser = import ../../../hosts/${config.networking.hostName}/home/tmpuser.nix;
  users.users.tmpuser = {
    isNormalUser = true;
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
      ]
      ++ ifTheyExist [
        "networkmanager"
        "libvirtd"
        "kvm"
        "docker"
        "podman"
        "git"
        "network"
        "i2c"
        "tss"
        "plugdev"
      ];

    initialPassword = "12345";
    packages = [ ];
  };
}
