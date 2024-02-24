{
  description = "My Home Manager & NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-colors.url = "github:Misterio77/nix-colors";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    waybar.url = "github:Alexays/Waybar";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      configs =
        let
          # List of directory names in ./hosts
          hostnames = (builtins.attrNames (nixpkgs.lib.attrsets.filterAttrs (name: val: val == "directory") (builtins.readDir ./hosts)));
          make_config = (hostname: {
            name = hostname;
            value = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                inherit inputs;
                inherit system;
              };
              modules = [
                ./hosts/${hostname}
              ];
            };
          });
        in
        builtins.listToAttrs (map make_config hostnames);
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = configs;
    };
}
