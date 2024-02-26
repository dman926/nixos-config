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
  -d, --dry           Execute non-destructively, effectively an alias for "-o dry-activate" on a non-ISO host.
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
OPT_SET=0
HN=$(hostname)
UPGRADE=""
DRY=""
upgradeText=""
VERBOSE=""

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -o | --opt)
    if [ $OPT_SET -eq 0 ]; then
      if [[ "$2" =~ ^(switch|boot|test|build|dry-build|dry-activate|edit|repl|build-vm|build-vm-with-bootloader|list-generations)$ ]]; then
        OPT="$2"
        OPT_SET=1
        shift
      else
        echo "Invalid option: \"$key $2\""
        help
        exit 1
      fi
    else
      # We want to ensure "--dry" takes precedence
      echo "Option already set: $OPT. Ignoring: \"$key $2\""
    fi
    ;;
  -hn | --hostname)
    HN="$2"
    shift
    ;;
  -u | --upgrade)
    UPGRADE="--upgrade-all"
    upgradeText="Upgrading and "
    ;;
  -d | --dry)
    OPT="dry-activate"
    DRY="--dry-run"
    if [ $OPT_SET -ne 0 ]; then
      echo "Warning: Option explicitly set: $OPT. Overridding with \"$key\""
    fi
    OPT_SET=1
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
  base_string="Building ISO"
  if [ -n "$DRY" ]; then
    echo "${base_string} (DRY RUN)"
  else
    echo "${base_string}"
  fi
  nix build .#nixosConfigurations.$HN.config.system.build.isoImage $DRY $VERBOSE
else
  base_string="${upgradeText}Building System"
  if [ -n "$DRY" ]; then
    echo "${base_string} (DRY RUN)"
  else
    echo "${base_string} with \"$OPT\""
  fi
  sudo nixos-rebuild $OPT $UPGRADE --flake .#$HN $VERBOSE
fi

exit 0
