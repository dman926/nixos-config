{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.modules.nixos.login;
  session = "Hyprland";
  tuigreeter =
    let
      tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    in
    ''${tuigreet} \
    --asterisks \
    --remember \
    --time --time-format '%Y-%m-%d@%H:%M:%S' \
    --cmd ${session}'';
in
{
  options.modules.nixos.login = {
    enable = mkEnableOption "login greeter";
    autoSignIn = mkEnableOption "automatic sign in";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = mkIf cfg.autoSignIn {
          command = session;
          user = "dj";
        };
        default_session = {
          command = tuigreeter;
          user = "greeter";
        };
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = true;

    environment.etc."greetd/environments".text = ''
      ${session}
    '';
  };
}
