nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/electron/disks.nix --arg device '"/dev/nvme0n1"'
