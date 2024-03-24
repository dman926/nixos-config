{ config
, pkgs
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [
    # This will get moved to an actual module eventually
    ./android-studio.nix
    ./vpn.nix
  ];

  home-manager.users.dj = import ../../../hosts/${config.networking.hostName}/home/dj.nix;
  sops.secrets = {
    dj-hashed-passwd = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };
  users.users.dj = {
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

    # initialPassword = "12345";
    hashedPasswordFile = config.sops.secrets.dj-hashed-passwd.path;
    packages = [ pkgs.home-manager ];
  };
}
