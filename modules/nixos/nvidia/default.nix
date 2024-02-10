{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Video acceleration
    libva

    # CUDA
    cudaPackages.cudatoolkit
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Disable features not available with GTX 1080
    powerManagement.enable = false; # Experimental
    powerManagement.finegrained = false;  # Experimental
    open = false;  # Alpha

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # CUDA
  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  };
}
