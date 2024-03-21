{ pkgs
, config
, lib
, ...
}:
with lib; let
  cfg = config.modules.nixos.vpn;
in
{
  options.modules.nixos.vpn = {
    enable = mkEnableOption "vpn";
  };

  config = mkIf cfg.enable {
    sops.secrets."pia/auth-user-pass" = {
      sopsFile = ../users/dj/secrets.yaml;
      owner = config.users.users.dj.name;
    };

    systemd.services =
      let
        upScript = pkgs.writeShellScript "openvpn-pia-up" '''';

        downScript = pkgs.writeShellScript "openvpn-pia-down" '''';

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
          value = {
            description = "Private Internet Access - ${fixup name}";
            serviceConfig = {
              ExecStart = ''${pkgs.openvpn}/bin/openvpn --script-security 2 --config ${resources}/${name} --auth-user-pass /run/secrets/pia/auth-user-pass --up "${upScript}" --down "${downScript}" --block-ipv6'';
            };
          };
        });
      in
      builtins.listToAttrs (map make_server servers);
  };
}
