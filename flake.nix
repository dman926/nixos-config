{
  description = "My Home Manager & NixOS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    comma.url = "github:nix-community/comma";

    disko.url = "github:nix-community/disko";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-colors.url = "github:Misterio77/nix-colors";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nwg-displays.url = "github:nwg-piotr/nwg-displays";

    scalpel.url = "github:polygon/scalpel";

    sops-nix.url = "github:Mic92/sops-nix";

    waybar.url = "github:Alexays/Waybar";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      host-systems =
        let
          # List of directory names in ./hosts
          hostnames =
            let
              extractDirs = lib.attrsets.filterAttrs (name: val: val == "directory");
            in
            (builtins.attrNames (extractDirs (builtins.readDir ./hosts)));
          make_system = hostname:
            let
              systemPath = ./hosts/${hostname}/system.nix;
            in
            if (builtins.pathExists systemPath) then {
              name = hostname;
              value = (import systemPath).system;
            } else null;
        in
        builtins.listToAttrs (lib.lists.remove null (map make_system hostnames));
      systems = lib.lists.unique (builtins.attrValues host-systems);
      eachSystem = lib.genAttrs systems;
      pkgsFor = eachSystem (system: nixpkgs.legacyPackages.${system});

      configs =
        let
          args = { inherit inputs outputs; };
          make_nixos = (hostname: system:
            lib.nixosSystem {
              specialArgs = args;
              modules = [
                ./hosts/${hostname}/configuration.nix
              ];
            });
          make_home_manager = (hostname: args:
            let
              system = args.system;
              users = args.users;
            in
            lib.attrsets.mapAttrs'
              (user: file: lib.attrsets.nameValuePair "${user}@${hostname}" (lib.homeManagerConfiguration {
                extraSpecialArgs = args;
                pkgs = pkgsFor.${system};
                modules = [ ./hosts/${hostname}/home/${file} ];
              }))
              users);
        in
        {
          nixosConfigurations = (builtins.mapAttrs make_nixos host-systems);
          # TODO: `infinite recursion encountered` error when building with home manager
          homeConfigurations =
            let
              userEntries = hostname:
                let
                  fixup = builtins.replaceStrings [ ".nix" ] [ "" ];
                  removeDefault = lib.attrsets.filterAttrs (name: val: name != "default.nix");
                  allUsernames = lib.attrsets.mapAttrs' (name: val: lib.attrsets.nameValuePair (fixup name) (val)) (removeDefault (builtins.readDir ./hosts/${hostname}/home));
                in
                builtins.mapAttrs (name: val: if (val == "directory") then name else "${name}.nix") allUsernames;
              mergedHomeNames = builtins.mapAttrs (name: val: { users = userEntries name; system = val; }) host-systems;
            in
            lib.attrsets.mergeAttrsList (lib.attrsets.mapAttrsToList make_home_manager mergedHomeNames);
        };
    in
    with configs; {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays { inherit inputs outputs; };
      packages = eachSystem (system: let pkgs = pkgsFor.${system}; in import ./pkgs { inherit pkgs; });
      devShells = eachSystem (system: let pkgs = pkgsFor.${system}; in import ./shell.nix { inherit pkgs inputs; });

      inherit nixosConfigurations;
      inherit homeConfigurations;

      formatter = eachSystem (system: pkgsFor.${system}.nixpkgs-fmt);
    };
}
