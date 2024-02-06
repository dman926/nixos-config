# TODO

## Config

- [x] Electron config
- [x] Neutron config
  - [x] [Nvidia GPU](https://nixos.wiki/wiki/Nvidia)
  - [x] [Cuda](https://nixos.wiki/wiki/CUDA) (I think I got it but gotta check)
  - [x] Monitors
  - [x] Disks
  - [ ] [Thermaltake RGB Software](https://github.com/chestm007/linux_thermaltake_riing) if it even works
- [ ] General
  - [ ] XDG
    - [x] XDG Base Directory Spec
    - [ ] Default Apps
  - [x] Config modularization
  - [ ] Home dir config
  - [ ] Keys
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
  - [ ] [Check this out for scaffolding server services](https://git.sr.ht/~rprospero/nixos-pia/tree/development/item/flake.nix) or set up my own thing, which seems like a bad idea
  - [ ] I would like a kill switch
- [x] QBittorrent
- [x] ffmpeg
- [x] My own handbrake
- [ ] Neovim
- [x] Discord
- [x] [Steam](https://nixos.wiki/wiki/Steam)
- [ ] Programming
  - [ ] NVM/Node
  - [ ] Python
  - [ ] Go
