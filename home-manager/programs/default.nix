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

    ./docker.nix
    # ./eza.nix
    ./fonts.nix
    # ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./kdeconnect.nix
    # ./modern-unix.nix
    ./photos.nix
    ./programming-langs
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    keymapp
    powertop

    nix-your-shell
    src-cli

    (lib.hiPrio parallel)
    moreutils
    nvtopPackages.full
    htop
    unzip
    gnupg
    yubikey-personalization

    nixd
    nixpkgs-fmt

    showmethekey

    cura
  ];
}
