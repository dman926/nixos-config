{ pkgs, ... }:
/*
Steam
Minecraft
*/
{
  environment.systemPackages = with pkgs; [
    steam-run

    # Minecraft
    prismlauncher
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;
}
