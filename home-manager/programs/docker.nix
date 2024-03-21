{ pkgs, ... }:
# TODO: look more into podman over docker
{
  home.packages = with pkgs; [
    podman-compose
    podman-tui
    lazydocker
  ];
}
