# { builtins, lib, ... }:
let
  builtins = import <nixpkgs> {};
  lib = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  configBasePath = ../../../openvpn-configs/pia;
  configFiles = builtins.filter (f: builtins.pathIsRegularFile f && lib.strings.hasSuffix ".ovpn" f) (builtins.attrNames configBasePath);
  configPaths = map (f: "${configBasePath}/${f}") configFiles;
  servers = builtins.listToAttrs configFiles (map (f: {
    config = '' config ${f} '';
    # TODO: I think the easiest way to get credentials in is to just pass from sops-nix here
    # but I might just make my own service cause I'm pretty limited
    authUserPass = {
      username = "";
      password = "";
    };
  }) configPaths);
in
{
  services.openvpn.servers = servers;
}