{ config
, pkgs
, ...
}:

{
  # TODO: make the pkg
  home.packages = [ pkgs.atuin-export-bash ];

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      # TODO: Update settings
      sync_address = "https://majiy00-shell.fly.dev";
      sync_frequency = "15m";
      dialect = "uk";
      enter_accept = false;
      records = true;
      # key_path = config.sops.secrets.atuin_key.path;
    };
  };

  #sops.secrets.atuin_key = {
  #  sopsFile = ../secrets.yaml;
  #};
}
