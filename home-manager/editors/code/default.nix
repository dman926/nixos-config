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
      userSettings = {
        # Shut up update notification
        "update.mode" = "none";
      } //
      (import ./settings.nix) //
      mkIf config.modules.wms.hyprland.enable {
        # Fix to get vscode to run on wayland
        "window.titleBarStyle" = "custom";
      };
    };
  };
}
