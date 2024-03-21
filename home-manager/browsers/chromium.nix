{ lib
, pkgs
, config
, ...
}:
with lib; let
  cfg = config.modules.browsers.chromium;
in
{
  options.modules.browsers.chromium = {
    enable = mkEnableOption "chromium browser";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      dictionaries = [
        pkgs.hunspellDictsChromium.en_US
      ];
      extensions = [
        {
          # Ublock Origin
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        }
        {
          # Click Color Picker
          id = "bfenhnialnnileognddgkbdgpknpfich";
        }
        {
          # Earth View from Google Earth
          id = "bhloflhklmhfpedakmangadcdofhnnoh";
        }
        {
          # Lighthouse
          id = "blipmdconlkpinefehnmjammfjpmpbjk";
        }
        {
          # Google Docs Offline
          id = "ghbmnnjooekpmoecnnnilnnbdlolhkhi";
        }
        {
          # Eternl
          id = "kmhcihpebfmpgmihbkipmjlmmioameka";
        }
        {
          # Google Keep
          id = "lpcaedmchfhocbbapmcbpinfpgnhiddi";
        }
        {
          # DuckDuckGo Privacy
          id = "bkdgflcldnnnapblkhphbgpggdiikppg";
        }
      ];
    };
  };
}
