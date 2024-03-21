{ pkgs
, lib
, ...
}:

{
  imports = [
    # ./atuin.nix
    # ./bat.nix
    # ./bottom.nix
    # ./cheat-sheets.nix
    ./direnv.nix

    # ./docker.nix
    # ./eza.nix
    ./fonts.nix
    # ./fzf.nix
    ./git.nix
    ./gpg
    # ./kdeconnect.nix
    # ./modern-unix.nix
    ./photos.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    keymapp
    powertop

    nix-your-shell
    src-cli

    (lib.hiPrio parallel)
    moreutils
    nvtop-amd
    htop
    unzip
    gnupg
    yubikey-personalization

    nixd
    nixpkgs-fmt

    showmethekey
  ];
}
