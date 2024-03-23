{ config
, lib
, ...
}:
with lib; let
  cfg = config.modules.nixos.docker;
in
{
  options.modules.nixos.docker = {
    enable = mkEnableOption "docker daemon or equivalent";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
    };

    environment.persistence = {
      "/persist/system".directories = [
        "/var/lib/containers"
      ];
    };
  };
}
