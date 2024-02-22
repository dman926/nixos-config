{ config, inputs, pkgs, lib, ... }:

{
  imports = [
    ./minimal.nix
    ./full.nix
  ];
}
