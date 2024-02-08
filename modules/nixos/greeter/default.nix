{ pkgs, inputs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${inputs.hyprland.packages."${pkgs.system}".hyprland}/bin/Hyprland";
  username = "dj";
in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = ''${tuigreet} \
        --asterisks \
        --remember \
        --time --time-format '%Y-%m-%d@%H:%M:%S' \
        --cmd ${session}
        '';
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
