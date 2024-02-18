#!/bin/sh

help() {
  cat <<EOF
Usage: $0 [options]

Options:
  -o, --opt OPT       Set the nixos-rebuild option. Ignored for 'quark' host (default: switch) {switch | boot | test | build | dry-build | dry-activate | edit | repl | build-vm | build-vm-with-bootloader | list-generations}
  -hn, --hostname HN   Set the hostname to rebuild (default: current hostname)
  -h, --help          Display this help message

Example:
  $0 -o boot -hn the-hostname

EOF
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  help
  exit 0
fi

if ! [ -f "./flake.nix" ]; then
  echo "No flake.nix in the current directory."
  echo "I suggest you run me in my directory."
  exit 1
fi

OPT="switch"
HN=$(hostname)

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -o|--opt)
      OPT="$2"
      shift
      ;;
    -hn|--hostname)
      HN="$2"
      shift
      ;;
    *)
      ;;
  esac

  shift
done

if [[ $# -gt 0 ]]; then
  echo "Warning: Extra arguments detected. Ignoring them."
fi

if [[ "$HN" == "quark" ]]; then
  echo "Building ISO"
  nix build .#nixosConfigurations.$HN.config.system.build.isoImage
else
  echo "Building System"
  sudo nixos-rebuild $OPT --flake .#$HN
fi

exit 0
