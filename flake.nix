{
  description = "My Home Manager & NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

  outputs = { self, nixpkgs, nixos-hardware, hyprland, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        electron = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit system;
          };
          modules = [
            nixos-hardware.nixosModules.framework-12th-gen-intel
            ./hosts/electron/configuration.nix
            hyprland.nixosModules.default
            home-manager.nixosModules.default
          ];
        };
        neutron = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit system;
          };
          modules = [
            ./hosts/neutron/configuration.nix
            hyprland.nixosModules.default
            home-manager.nixosModules.default
          ];
        };
      };
    };
}
