# TODO

## Customization

- [x] [Bluetooth](https://nixos.wiki/wiki/Bluetooth) and [Pipewire integration](https://nixos.wiki/wiki/PipeWire#Bluetooth_Configuration) (Shouldn't need to mess with Pipewire)
- [ ] [CAVA](https://github.com/karlstav/cava) with [waybar module](https://github.com/Alexays/Waybar/wiki/Module:-Cava)
- [ ] Look into [gamemode](https://github.com/Alexays/Waybar/wiki/Module:-Gamemode)
- [ ] Waybar VPN status / mako notifications
- [ ] Theming unification
  - [x] nix-colors
  - [x] Hyprland integration
  - [x] Mako integration
  - [ ] Waybar integration
  - [ ] Oh-my-posh integration (custom theme)
  - [ ] Terminal integration

## Programs

- [x] [VPN](https://nixos.wiki/wiki/OpenVPN) (PIA over OpenVPN)
  - [x] Setup module for switch to load configs
  - [x] Safely store PIA credentials
  - [x] Scaffold services
  - [ ] I would like a kill switch
- [x] QBittorrent
- [x] oh-my-posh
- [x] ffmpeg
- [x] 3d modeling / printing
- [x] My own handbrake (transcoder.sh)
- [x] Neovim
- [x] Discord
- [x] [Steam](https://nixos.wiki/wiki/Steam)
- [x] Programming
  - [x] NVM/Node
  - [x] Python
  - [x] Go
- [ ] Custom programs
  - [x] Move `./rebuild.sh` to a proper nix bash script
  - [x] Make `transcoder.sh` a proper bash script
  - [ ] Make dev-env
- [ ] Warp terminal
- [ ] [Thermaltake RGB Software](https://github.com/chestm007/linux_thermaltake_riing) if it even works


## Config

- [x] Quark config (minimal live cd iso)
  - In the future, I will want to preload tools I use with it. Possible tools:
    - Basic ISOs and Etcher or a lightweight load script. It would be cool if I were able to dynamically load and multiboot on the same USB drive easily.
    - Drive/partition utilities with windows support (NTFS)
    - Preloaded installers (Nianite or individual)
      - Probably best if there is a separate NTFS partition for any OS booted from the USB to access these and ISOs.
- [x] Electron config
  - [x] Top row hotkeys are not working (F1-F8 multi-media keys). Probably also related to Neutron USB soundcard volume controls not working. [Potential fix](https://github.com/NixOS/nixpkgs/issues/24297#issuecomment-538698801). [See pw-volume](https://github.com/smasher164/pw-volume)
- [x] Neutron config (all good until device arives to test)
- [x] Hydrogen config
  - [x] [Nvidia GPU](https://nixos.wiki/wiki/Nvidia)
  - [x] [Cuda](https://nixos.wiki/wiki/CUDA) (I think I got it but gotta check)
  - [x] Monitors
  - [x] Disks
- [x] General
  - [x] XDG
    - [x] XDG Base Directory Spec
    - [x] XDG User Directory Spec
    - [x] Default Apps
  - [x] Config modularization
  - [x] Home dir config
  - [x] Keys
    - [x] SSH Key
    - [x] GPG Key / [Yubikey Setup](https://rzetterberg.github.io/yubikey-gpg-nixos.html)
    - [x] [Yubikey PAM](https://nixos.wiki/wiki/Yubikey)
      - [x] Sudo
      - [x] Login with TuiGreeter
  - [x] Secrets with [sops-nix](https://github.com/Mic92/sops-nix)
  - [x] Low battery notification daemon
