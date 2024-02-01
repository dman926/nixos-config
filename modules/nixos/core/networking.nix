{ ... }:

{
  networking.networkmanager.enable = true;

  # Start NetworkManager on login
  systemd.services.NetworkManager.wantedBy = [ "multi-user.target" ];

  time.timeZone = "America/New_York";
}