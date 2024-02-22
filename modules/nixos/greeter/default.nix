{ pkgs, inputs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  # session really should be `"${inputs.hyprland.packages."${pkgs.system}".hyprland}/bin/Hyprland";`
  # but I like tuigreet to show the command as `Hyprland`
  session = "Hyprland";
in
{
  services.greetd = {
    enable = true;
    settings = {
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

  security.pam.services.greetd.enableKwallet = true;

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
