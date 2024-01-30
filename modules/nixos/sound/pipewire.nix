{ ... }:
# Probably want a GUI like pavucontrol to control this
{
  # Sound with pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };
  services.mpd = {
    enable = true;
    extraConfig = ''
      type "pipewire"
      name "PipeWire"
    '';

    network.listenAddress = "any";
    startWhenNeeded = true;
  };
  # Run MPD as with the same user as pipewire
  systemd.services.mpd.environment.XDG_RUNTIME_DIR = "/run/user/1000";
}