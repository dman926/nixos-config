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
    # ${pkgs.iptables}/bin/iptables-save > /home/dj/.config/openvpn/og-iptables.rules
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
    # ${pkgs.iptables}/bin/iptables-restore < /home/dj/.config/openvpn/og-iptables.rules
    # rm /home/dj/.config/openvpn/og-iptables.rules
    
    ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf

    # ${pkgs.libnotify}/bin/notify-send "VPN stopped at $(${pkgs.coreutils-full}/bin/date +%Y-%m-%d@%H:%M:%S)"
  '';

  pia-services =
    let
      resources = pkgs.fetchzip {
        name = "pia-vpn-config";
        url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
        sha256 = "ZA8RS6eIjMVQfBt+9hYyhaq8LByy5oJaO9Ed+x8KtW8=";
        stripRoot = false;
      };
      fixup = (builtins.replaceStrings [ ".ovpn" "_" ] [ "" "-" ]);
      servers =
        (builtins.filter (name: !(isNull (builtins.match ".+ovpn$" name)))
          (builtins.attrNames (builtins.readDir resources)));
      make_server = (name: {
        name = fixup "openvpn-${name}";
        # Actual service config
        value = {
          description = "Private Internet Access - ${fixup name}";
          before = [ "openvpn-pia.service" ];
          environment = {
            DISPLAY = ":0";
            WAYLAND_DISPLAY = "wayland-0";
          };
          serviceConfig = {
            ExecStart = ''${pkgs.openvpn}/bin/openvpn --script-security 2 --config ${resources}/${name} --auth-user-pass /home/dj/.config/openvpn/pia-auth --up "${upScript}" --down "${downScript}" --block-ipv6'';
            # TODO: killswitch monitor
            # ExecStartPost = '' '';

            # Restart = "always";
            # RestartSec = 3;
          };
        };
      });
    in
    builtins.listToAttrs (map make_server servers);

  /*
    pia-manager = pkgs.writeShellScriptBin "openvpn-pia-manager" ''
    active_connections=$(${pkgs.pcrops}/bin/pgrep -f openvpn | ${pkgs.coreutils-full}/bin/wc -1)

    best_latency=99999
    best_service=""

    if [[ $active_connections -eq 0 ]]; then
      for service in "${builtins.attrNames pia-services}"; do
        latency=$()

        if [[  ]]; then
          best_latency=$server_latency
          best_service=$service
        fi
      done

      ${pkgs.systemctl}/bin/systemctl start "openvpn@$service"
    fi

    exit 0
  ''; */
in
{
  services.resolved.enable = true;

  # Build openvpn service configs
  systemd.services = pia-services; /* // {
  # PIA group
  openvpn-pia = {
      description = "OpenVPN PIA Single-Instance Group";
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ""
      };
  }
  }; */
}
