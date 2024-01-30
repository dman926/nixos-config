{ pkgs, ... }:

{
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  services.pcscd.enable = true;

  # Enable u2f PAM module for login and sudo
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Lock screen on hardware key removal
  # TODO: enable when done messing with keys
  # services.udev.extraRules = ''
  #   ACTION=="remove",\
  #     ENV{ID_BUS}=="usb",\
  #     ENV{ID_MODEL_ID}=="0407",\
  #     ENV{ID_VENDOR_ID}=="1050",\
  #     ENV{ID_VENDOR}=="Yubico",\
  #     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  # '';
}
