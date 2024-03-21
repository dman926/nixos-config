{
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      # TODO: uncomment when host keys is figured out
      # PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };
  };
}
