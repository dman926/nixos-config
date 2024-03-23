{ pkgs
, config
, ...
}:

{
  home.packages = with pkgs; [
    libsecret
    pinentry-gnome3
    gnome.seahorse
  ];

  services.gnome-keyring.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    pinentryFlavor = "gnome3";
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      reader-port = "Yubico Yubi";
      disable-ccid = true;
    };
  };
}
