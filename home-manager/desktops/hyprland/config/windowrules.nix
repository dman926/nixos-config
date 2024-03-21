{ lib, ... }:
let
  rule = rules: attrs: attrs // { inherit rules; };
in
{
  wayland.windowManager.hyprland.settings.windowrulev2 =
    let
      # TODO: My rules
      firefoxVideo = {
        class = [ "firefox" ];
      };
      guildWars = {
        title = [ "Guild Wars 2" ];
      };
    in
    lib.concatLists [
      (map (rule [ "idleinhibit fullscreen" ]) [ firefoxVideo ])
      (map (rule [ "fullscreen" ]) [ guildWars ])
    ];
}
