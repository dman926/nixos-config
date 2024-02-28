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

  -e, --edit          Edit the nixos configuration
  -u, --upgrade       Upgrade when running nixos-rebuild. Ignored for ISO hosts
  -d, --dry           Execute non-destructively, effectively an alias for "-o dry-activate" on a non-ISO host
  -l, --log           Echo the latest log to stdout and exit
  -h, --help          Display this help message and exit

Example:
  Rebuild the system (with the 'boot' option) on the 'the-hostname' host and upgrade
  $ $ZERO -o boot -hn the-hostname -u

ISO hosts:
  - quark

EOF
}

LOGDIR=logs

OPT="switch"
OPT_SET=0
HN=$(hostname)
EDIT=0
UPGRADE=""
DRY=""
upgradeText=""

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
  -e | --edit)
    EDIT=1
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
  -l | --log)
    if [[ -d $LOGDIR ]]; then
      latest_log=$(ls $LOGDIR/*.log | tail -n 1)
      cat $latest_log | less
    else
      echo "No logs in $LOGDIR"
    fi
    exit 0
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
  echo "File not found: $(pwd)/flake.nix"
  exit 2
fi

if [ $EDIT -eq 1 ]; then
  nvim .
  # TODO: New files don't get considered
  nix fmt . &>/dev/null
  git diff -U0 *.nix
fi

LOGFILE=$LOGDIR/$(date +"%Y-%m-%d-%H-%M-%S").log
mkdir -p $LOGDIR

# Don't let the logs build up
ls logs/*.log &>/dev/null && ls logs/*.log | head -n -5 | sed 's/./\\&/g' | xargs -r rm --

if [[ "$HN" == "quark" ]]; then
  base_string="Building ISO \"$HN\""
  if [ -n "$DRY" ]; then
    echo "${base_string} (DRY RUN)"
  else
    echo "${base_string}"
  fi
  nix build .#nixosConfigurations.$HN.config.system.build.isoImage $DRY --show-trace &>$LOGFILE
else
  base_string="${upgradeText}Building System \"$HN\""
  if [ -n "$DRY" ]; then
    echo "${base_string} (DRY RUN)"
  else
    echo "${base_string} with \"$OPT\""
  fi
  sudo nixos-rebuild $OPT $UPGRADE --flake .#$HN --show-trace &>$LOGFILE
fi

if [[ $? -ne 0 ]]; then
  err=$(cat $LOGFILE | grep -A 1 --color "error: ")
  if [ -n "$err" ]; then
    echo "$err"
  else
    # Not all errors actually have the pattern "error: "
    # Mostly sudo issues
    cat $LOGFILE
  fi
  exit 1
fi

if [ -z "$DRY" ]; then
  nixos-rebuild list-generations | head -n 2
fi

exit 0
