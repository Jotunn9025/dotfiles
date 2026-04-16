{ config, lib, ... }:

with lib;
let cfg = config.system.desktop;
in {
  options.system.desktop = {
    enable = mkEnableOption "GNOME Desktop Environment, X11, and Printing";
  };

  config = mkIf cfg.enable {
    # X11 Windowing & Keymap
    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # GNOME Desktop
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Printing
    services.printing.enable = true;

    home-manager.users.youhan = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
  };

}