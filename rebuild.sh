#!/bin/sh

if ! [ -f "./flake.nix" ]; then
  echo "No flake.nix in the current directory."
  echo "I suggest you run me in my directory."
  exit 1
fi

if [[ -z "$1" ]]; then
  OPT="switch"
else
  OPT="$1"
fi

sudo nixos-rebuild $OPT --flake .#$(echo $HOSTNAME)

exit 0
