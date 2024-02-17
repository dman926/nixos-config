{ config, lib, ... }:

{
  config = lib.mkMerge [
    (lib.mkIf config.full-install {
      networking = {
        networkmanager.enable = true;
      };

      # Start NetworkManager on login
      systemd.services.NetworkManager.wantedBy = [ "multi-user.target" ];

      time.timeZone = "America/New_York";
    })

    {
      # Open samba ports
      networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
    }
  ];
}
