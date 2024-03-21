{ pkgs, ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      full = true;
      no_display = true;
      cpu_load_change = true;
    };
  };

  home.packages = with pkgs; [
    lutris
    vesktop
    cartridges
    bottles
    # TODO: make pkg if wanted
    adwaita-for-steam
  ];
}
