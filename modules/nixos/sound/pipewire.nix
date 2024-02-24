{ config, lib, ... }:
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

  # Add bluez rules if enabled
  environment.etc = lib.mkIf config.hardware.bluetooth.enable {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      		bluez_monitor.properties = {
      			["bluez5.enable-sbc-xq"] = true,
      			["bluez5.enable-msbc"] = true,
      			["bluez5.enable-hw-volume"] = true,
      			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      		}
      	'';
  };
}
