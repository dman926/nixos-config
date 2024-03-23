# TODO

- Other system configs
- Nvidia
- qBitorrent
- Desktop environments
  - [ ] Gnome
  - [ ] Plasma
- Update GDK style / use theme

- Resources:
  - Nix dev workflow
    1. https://haseebmajid.dev/posts/2023-07-20-nixos-as-part-of-your-development-workflow/
    2. https://haseebmajid.dev/posts/2023-10-24-part-2-how-to-setup-nixos-as-part-of-your-development-workflow/
    3. https://haseebmajid.dev/posts/2023-11-15-part-3-hyprland-as-part-of-your-development-workflow/
    4. https://haseebmajid.dev/posts/2024-01-05-part-4-wezterm-terminal-as-part-of-your-development-workflow/
  - https://haseebmajid.dev/posts/2023-09-12-how-i-configure-nixos-as-part-of-my-development-workflow/
  - https://haseebmajid.dev/posts/2023-10-08-how-to-create-systemd-services-in-nix-home-manager/
  - https://haseebmajid.dev/posts/2023-10-26-how-to-setup-a-go-development-shell-with-nix-flakes/
  - https://haseebmajid.dev/posts/2023-11-10-how-to-set-network-manager-priority-to-use-wired-connection-over-wifi/
  - https://haseebmajid.dev/posts/2023-11-18-how-i-setup-my-raspberry-pi-cluster-with-nixos/
  - https://haseebmajid.dev/posts/2024-02-04-how-to-create-a-custom-nixos-iso/

# Old TODOs below

## Customization

- [x] [Bluetooth](https://nixos.wiki/wiki/Bluetooth) and [Pipewire integration](https://nixos.wiki/wiki/PipeWire#Bluetooth_Configuration) (Shouldn't need to mess with Pipewire)
- [ ] [CAVA](https://github.com/karlstav/cava) with [waybar module](https://github.com/Alexays/Waybar/wiki/Module:-Cava)
- [ ] Look into [gamemode](https://github.com/Alexays/Waybar/wiki/Module:-Gamemode)
- [ ] Waybar VPN status / mako notifications
- [ ] Theming unification
  - [x] GTK/QT Breeze dark
  - [x] nix-colors
    - [x] Hyprland integration
    - [x] Mako integration
    - [x] Waybar integration
      - [x] Custom theme (Basically done but I can't color to save my life)
    - [ ] Oh-my-posh integration (custom theme)
    - [x] Terminal integration

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
- [x] Discord/Vesktop
- [x] [Steam](https://nixos.wiki/wiki/Steam)
- [x] Programming
  - [x] NVM/Node
  - [x] Python
  - [x] Go
- [ ] Custom programs
  - [x] Move `./rebuild.sh` to a proper nix bash script
  - [x] Make `transcoder.sh` a proper bash script
  - [ ] Make dev-env
- [ ] Warp terminal (PR is merged. Waiting to be available in unstable)
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
  - [ ] Idle lock
  - [ ] Laptop lid-close lock
  - [ ] Clipboard seems to be messed up a little. Issue occurring while interacting with a Ubuntu virtual machine through the web browser, so it's probably just wack there, and rightly so.
