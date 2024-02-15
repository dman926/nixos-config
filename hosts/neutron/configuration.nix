{ inputs, ... }:
# Framework 16
{
  imports =
    [
      # inputs.nixos-hardware.nixosModules.framework-16
      # ./hardware-configuration.nix

      ../default
      ../../users/dj

      ../../modules/nixos/secrets
      ../../modules/nixos/core
      ../../modules/nixos/greeter
      ../../modules/nixos/keys
      ../../modules/nixos/openvpn
      ../../modules/nixos/sound
      ../../modules/nixos/steam
    ];

  networking.hostName = "neutron";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
