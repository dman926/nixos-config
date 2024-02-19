{ config, inputs, pkgs, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.hyprland.nixosModules.default

    ../../programs/scripts
  ];

  config = lib.mkMerge [
    (lib.mkIf config.full-install {
      # For etcher
      nixpkgs.config.permittedInsecurePackages = [
        "electron-19.1.9"
      ];

      environment.systemPackages = with pkgs; [
        qbittorrent
        ffmpeg-full

        discord
        # Discord screensharing with audio in Wayland
        vesktop
      ];
    })

    {
      environment.systemPackages = with pkgs; [
        libsecret
        gnome.gnome-keyring

        # use eww when it gets more complex, waybar works for now
        # eww
        mako
        libnotify # Dependency of mako
        swww
        kitty # TODO: find a better terminal if any
        rofi-wayland
        # Wayland deps
        libsForQt5.qt5.qtwayland # qt5-wayland
        libsForQt5.qt5ct

        samba
        libsForQt5.ark
        gnome.seahorse

        pavucontrol
      ];

      environment.sessionVariables = {
        # Wayland/Hyprland vars
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        GTK_USE_PORTAL = "1";
        NIXOS_XDG_OPEN_USE_PORTAL = "1";
        NIXOS_OZONE_WL = "1";
      };

      users.groups.dj = { };

      users.users.dj = {
        isNormalUser = true;
        description = "DJ Stelmach";
        group = "dj";
        extraGroups = [ "networkmanager" "wheel" "input" ];
      };

      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          (nerdfonts.override { fonts = [ "Hasklig" ]; })
          font-awesome
        ];
        fontconfig = {
          enable = true;
          defaultFonts.monospace = with pkgs; [
            "Hasklig Mono"
          ];
        };
      };

      home-manager = {
        extraSpecialArgs = with config; {
          inherit inputs;
          inherit full-install;
          # Machine identification for fine-tuning
          hostName = config.networking.hostName;
          use-nvidia = config.hardware.nvidia.modesetting.enable;
        };
        useGlobalPkgs = true;
        useUserPackages = true;
        users."dj" = import ./home.nix;
      };

      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
        portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
      };

      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
        ];
      };
    }
  ];
}
