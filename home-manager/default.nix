{ inputs
, lib
, pkgs
, config
, outputs
, ...
}:

{
  imports =
    [
      inputs.nix-colors.homeManagerModule
      inputs.nixvim.homeManagerModules.nixvim

      ./programs
      # ./scripts.nix

      ./browsers/chromium.nix
      ./browsers/firefox.nix

      ./editors/code
      # ./editors/nvim

      ./multiplexers/tmux.nix

      ./desktops/hyprland

      ./shells/prompts/oh-my-posh.nix
      ./shells/bash.nix

      ./terminals/kitty
      ./terminals/warp.nix

      ./security/sops.nix
      ./security/persistence.nix
    ]
    ++ builtins.attrValues outputs.homeManagerModules;

  programs = {
    home-manager.enable = true;
  };

  home.sessionVariables.EDITOR = config.my.settings.default.editor;

  nixpkgs = {
    overlays =
      builtins.attrValues outputs.overlays;
    # ++ [
    #   TODO: I don't think I need these.
    #   or at least not for now
    #   inputs.nixneovimplugins.overlays.default
    #   inputs.neovim-nightly-overlay.overlay
    # ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      extra-substituters = [
        "https://cache.floxdev.com"
      ];

      extra-trusted-public-keys = [
        "flox-store-public-0:8c/B+kjIaQ+BloCmNkRUKwaVPFWkriSAd0JJvuDu4F0="
      ];

      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
      use-xdg-base-directories = true;
      netrc-file = "$HOME/.config/nix/netrc";
    };
  };

  news = {
    display = "silent";
    json = lib.mkForce { };
    entries = lib.mkForce [ ];
  };
}
