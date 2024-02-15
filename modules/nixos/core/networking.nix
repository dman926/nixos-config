{ ... }:

{
  networking = {
    networkmanager.enable = true;
    # Open samba ports
    firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  };

  # Start NetworkManager on login
  systemd.services.NetworkManager.wantedBy = [ "multi-user.target" ];

  time.timeZone = "America/New_York";
}
