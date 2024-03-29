{ config, lib, ... }:
let
  full-install = config.install-level == "full";
in
{
  config = lib.mkMerge [
    (lib.mkIf full-install {
      networking.networkmanager.enable = true;

      time.timeZone = "America/New_York";
    })

    {
      # Open samba ports
      networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
    }
  ];
}
