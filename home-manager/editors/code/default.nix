{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.editors.code;
in
{
  options.modules.editors.code = {
    enable = mkEnableOption "VSCode editor";
  };

  imports = [
    ./writable-settings.nix
  ];

  config = mkIf cfg.enable {
    # TODO: additional settings

    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      userSettings =
        let
          userSettings = import ./settings.nix;
        in
        {
          # Shut up update notification
          "update.mode" = "none";
        } //
        userSettings //
        (if config.modules.wms.hyprland.enable then {
          # Fix to get vscode to run on wayland
          "window.titleBarStyle" = "custom";
        } else { });
    };
  };
}
