{ config, inputs, lib, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/srv"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/ssh"
      "/var/lib/bluetooth"
      "/var/lib/cups"
      "/var/lib/fprint"
      "/var/lib/nixos"
      "/var/lib/sops-nix"
      "/var/lib/systemd"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  programs.fuse.userAllowOther = true;
}
