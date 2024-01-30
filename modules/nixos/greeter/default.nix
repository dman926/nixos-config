{ pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

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
