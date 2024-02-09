# TODO

## Config

- [x] Electron config
  - [ ] Top row hotkeys are not working (F1-F8 multi-media keys). Probably also related to Neutron USB soundcard volume controls not working. [Potential fix](https://github.com/NixOS/nixpkgs/issues/24297#issuecomment-538698801). [See pw-volume](https://github.com/smasher164/pw-volume)
- [x] Neutron config
  - [x] [Nvidia GPU](https://nixos.wiki/wiki/Nvidia)
  - [x] [Cuda](https://nixos.wiki/wiki/CUDA) (I think I got it but gotta check)
  - [x] Monitors
  - [x] Disks
  - [ ] [Thermaltake RGB Software](https://github.com/chestm007/linux_thermaltake_riing) if it even works
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
    - [ ] [Yubikey PAM](https://nixos.wiki/wiki/Yubikey)
      - [x] Sudo
      - [ ] Login with TuiGreeter
  - [x] Secrets with [sops-nix](https://github.com/Mic92/sops-nix)
  - [x] Low battery notification daemon

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
- [x] My own handbrake
- [x] Neovim
- [x] Discord
- [x] [Steam](https://nixos.wiki/wiki/Steam)
- [ ] Programming
  - [ ] NVM/Node
  - [ ] Python
  - [ ] Go
