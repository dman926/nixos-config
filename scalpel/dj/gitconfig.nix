{ config, outputs, lib, pkgs, prev, ... }:
let
  gitconfig_text = "${prev.config.home.file."/home/dj/.config/git/config".text}";
  gitconfig_file = "${prev.config.home.file."/home/dj/.config/git/config".target}";
in
{
  home.file."/home/dj/.config/git/config".text = lib.mkForce (
    builtins.replaceStrings [ gitconfig_file ] [ config.scalpel.trafos.".gitconfig".destination ] gitconfig_text
  );
  scalpel.trafos.".gitconfig" = {
    source = gitconfig_file;
    matchers."GIT_SIGNING_KEY".secret = config.sops.secrets.dj-signing-key.path;
    owner = prev.config.home.user.user;
    group = prev.config.home.user.group;
    mode = "0440";
  };
}
