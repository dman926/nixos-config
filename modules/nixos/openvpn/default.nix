{ config, pkgs, ... }:
let
  upScript = pkgs.writeShellScript "openvpn-pia-up" ''
    # For convenience in client scripts, extract the remote domain
    # name and name server.
    # for var in ''${!foreign_option_*}; do
    #   x=(''${!var})
    #   if [ "''${x[0]}" = dhcp-option ]; then
    #     if [ "''${x[1]}" = DOMAIN ]; then domain="''${x[2]}"
    #     elif [ "''${x[1]}" = DNS ]; then nameserver="''${x[2]}"
    #     fi
    #   fi
    # done

    # ${pkgs.coreutils-full}/bin/sleep 3

    # Kill traffic outside VPN
    # ${pkgs.iptables}/bin/iptables-save > /home/dj/.config/openvpn-configs/og-iptables.rules
    # ${pkgs.iptables}/bin/iptables -F
    # echo "0";
    # ${pkgs.iptables}/bin/iptables -A INPUT -i ! tun0 -j DROP
    # echo "1";
    # ${pkgs.iptables}/bin/iptables -A OUTPUT -o ! tun0 -j DROP
    # echo "2";
    # ${pkgs.iptables}/bin/iptables -A INPUT -i tun0 -j ACCEPT
    # echo "3";
    # ${pkgs.iptables}/bin/iptables -A OUTPUT -o tun0 -j ACCEPT
    # echo "4";

    ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf

    # ${pkgs.libnotify}/bin/notify-send -t 3500 "VPN ready at $(${pkgs.coreutils-full}/bin/date +%Y-%m-%d@%H:%M:%S)"
  '';

  downScript = pkgs.writeShellScript "openvpn-pia-down" ''
    # ${pkgs.coreutils-full}/bin/sleep 3
    
    # Restore iptables
    # ${pkgs.iptables}/bin/iptables-restore < /home/dj/.config/openvpn-configs/og-iptables.rules
    # rm /home/dj/.config/openvpn-configs/og-iptables.rules
    
    ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf

    # ${pkgs.libnotify}/bin/notify-send "VPN stopped at $(${pkgs.coreutils-full}/bin/date +%Y-%m-%d@%H:%M:%S)"
  '';
in
{
  services.resolved.enable = true;

  systemd.services = {
    openvpn-pia = {
      description = "Private Internet Access via OpenVPN";
      after = [ "network.target" ];
      environment = {
        DISPLAY = ":0";
        WAYLAND_DISPLAY = "wayland-0";
      };
      serviceConfig = {
        ExecStart = ''${pkgs.openvpn}/bin/openvpn --script-security 2 --config /home/dj/.config/openvpn-configs/pia/ca_montreal.ovpn --auth-user-pass /home/dj/.config/openvpn-configs/pia-auth --up "${upScript}" --down "${downScript}" --block-ipv6'';
        # TODO: killswitch monitor
        # ExecStartPost = '' '';

        # Restart = "always";
        # RestartSec = 3;
      };
    };
  };
}