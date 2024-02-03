{ pkgs, ... }:
let
  command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --remember \
    --time --time-format '%Y-%m-%d@%H:%M:%S' \
    --cmd 'dbus-run-session Hyprland'
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        inherit command;
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    # Prevent errors spamming the screen
    StandardError = "journal";
    # Prevent bootlogs spamming screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
