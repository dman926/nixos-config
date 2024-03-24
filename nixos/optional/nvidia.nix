{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.modules.nixos.nvidia;
in
{
  options.modules.nixos.nvidia = {
    enable = mkEnableOption "nvidia";
    enableCuda = mkEnableOption "cuda";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = mkMerge (with pkgs; [
      [
        # Video acceleration
        libva
      ]

      (mkIf cfg.enableCuda [
        # CUDA
        cudaPackages.cudatoolkit
      ])
    ]);

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;

      # Disable features not available with GTX 1080
      powerManagement = {
        enable = false; # Experimental
        finegrained = false; # Experimental
      };
      open = false; # Alpha

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # CUDA
    systemd.services.nvidia-control-devices = mkIf cfg.enableCuda {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };
  };
}
