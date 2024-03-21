{ device ? throw "Set this to your disk device, e.g. /dev/sda"
, ...
}:

{
  disko.devices = {
    disk.main = {
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
                  mountOptions = [ "subvol=root" /*"compress=zstd"*/ ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "subvol=home" /*"compress=zstd"*/ "noatime" ];
                };
                # "/home/games" = { };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "subvol=nix" /*"compress=zstd"*/ "noatime" ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "subvol=persist" /*"compress=zstd"*/ "noatime" ];
                };
                /*
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "subvol=log" "compress=zstd" "noatime" ];
                };
                        		*/
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
