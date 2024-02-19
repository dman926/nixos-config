#!/usr/bin/env bash

help() {
  ZERO="$0"
  if [[ "${ZERO::1}" == "/" ]]; then
    ZERO=$(basename $ZERO)
  fi
  cat <<EOF
Usage: $ZERO [options]

Options:
  -o, --opt OPT       Set the nixos-rebuild option. Ignored for ISO hosts. (default: switch)
      {switch | boot | test | build | dry-build | dry-activate | edit | repl | build-vm | build-vm-with-bootloader | list-generations}
  -hn, --hostname HN  Set the hostname to rebuild (default: current hostname [ $(hostname) ]))

  -u, --upgrade       Upgrade when running nixos-rebuild. Ignored for ISO hosts.
  -v, --verbose       Verbose output (--show-trace)
  -h, --help          Display this help message

Example:
  Rebuild the system (with the 'boot' option) on the 'the-hostname' host and upgrade
  $ $ZERO -o boot -hn the-hostname -u

ISO hosts:
  - quark

EOF
}

OPT="switch"
HN=$(hostname)
UPGRADE=""
VERBOSE=""

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -o | --opt)
    OPT="$2"
    shift
    ;;
  -hn | --hostname)
    HN="$2"
    shift
    ;;
  -u | --upgrade)
    UPGRADE="--upgrade-all"
    ;;
  -v | --verbose)
    VERBOSE="--show-trace"
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *) ;;
  esac

  shift
done

if [[ $# -gt 0 ]]; then
  echo "Warning: Extra arguments detected. Ignoring them."
fi

# Get's swapped out when used in a system
# config-home PLACEHOLDER

if ! [ -f "./flake.nix" ]; then
  echo "No flake.nix in the current directory."
  echo "I suggest you run me in my directory."
  exit 1
fi

if [[ "$HN" == "quark" ]]; then
  echo "Building ISO"
  nix build .#nixosConfigurations.$HN.config.system.build.isoImage $VERBOSE
else
  echo "Building System"
  sudo nixos-rebuild $OPT $UPGRADE --flake .#$HN $VERBOSE
fi

exit 0
