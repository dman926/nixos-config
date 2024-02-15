{ pkgs ? import <nixpkgs> {} }:
# virtualenv nixpkg is messed up right now
# but creating through a shell.nix works fine.
# https://github.com/NixOS/nixpkgs/issues/225730
pkgs.mkShell {
  packages = with pkgs; [
    (python3.withPackages (python-pkgs: [
      python-pkgs.virtualenv
    ]))
    pdm
  ];
}
