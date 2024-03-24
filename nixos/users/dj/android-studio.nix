{ ... }:

{
  programs.adb.enable = true;
  users.users.dj.extraGroups = ["adbusers"];
}