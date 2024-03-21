{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # TODO: handle custom locations with an environment variable or overrides when installing in config
  media-processor = pkgs.callPackage ./media-processor { };
  nix-rebuild = pkgs.callPackage ./nix-rebuild { };

  # I can see why it's not in nixpkgs
  # ccstudio = pkgs.callPackage ./ccstudio.nix { };
}
