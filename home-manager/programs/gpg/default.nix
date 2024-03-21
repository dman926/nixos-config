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

  # systemd.user.sockets.gpg-agent = {
  #   listenStreams = let
  #     user = "haseeb";
  #     socketDir =
  #       pkgs.runCommand "gnupg-socketdir" {
  #         nativeBuildInputs = [pkgs.python3];
  #       } ''
  #         python3 ${./gnupgdir.py} '/home/${user}/.local/share/gnupg' > $out
  #       '';
  #   in [
  #     "" # unset
  #     "%t/gnupg/${builtins.readFile socketDir}/S.gpg-agent"
  #   ];
  # };
}
