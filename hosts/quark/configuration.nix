{ inputs, ... }:

{
  install-level = "minimal";

  imports =
    [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

      ../default

      ../../modules/nixos/core/i18n.nix
      ../../modules/nixos/core/networking.nix
      ../../modules/nixos/bluetooth
      ../../modules/nixos/greeter
      ../../modules/nixos/sound
    ];

  networking.hostName = "quark";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
