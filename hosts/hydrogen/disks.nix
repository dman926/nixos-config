{ device ? throw "Set this to your disk device, e.g. /dev/nvme0n1"
, gameDevice ? null
, hardStorageDevice ? null
, lib
, ...
}:

{
  disko.devices = {
    disk = {
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "64G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "electron_vg";
              };
            };
          };
        };
      } //
      (lib.mkIf (gameDevice != null) {
        game0 = {
          device = gameDevice;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              game0 = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/media/game0";
                };
              };
            };
          };
        };
      }) //
      (lib.mkIf (hardStorageDevice != null) {
        memebigboi = {
          device = hardStorageDevice;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              memebigboi = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/media/memebigboi";
                };
              };
            };
          };
        };
      });
    };
    lvm_vg = {
      electron_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "subvol=root" ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "subvol=home" "noatime" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "subvol=nix" "noatime" ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "subvol=persist" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
