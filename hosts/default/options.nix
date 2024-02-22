{ lib, ... }:

{
  options = {
    script-config = {
      nixos-config-home = lib.mkOption {
        description = "NixOS config home on the system";
        type = lib.types.str;
      };
      media-processor.enable = lib.mkOption {
        description = "Enable the transcoder and renamer scripts";
        type = lib.types.bool;
        default = false;
      };
      media-processor.work-dir = lib.mkOption {
        description = "Where to output. It should be an absolute path **string**";
        type = lib.types.str;
      };
    };

    install-level = lib.mkOption {
      description = "Installation level (minimal / full install)";
      type = lib.types.enum [ "minimal" "full" ];
      default = "full";
    };
  };
}
