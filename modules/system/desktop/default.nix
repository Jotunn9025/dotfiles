{ config, lib, pkgs, inputs, ... }:

with lib;
let 
  cfg = config.system.desktop;
  hm = inputs.home-manager.lib.hm;
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

    # 1. Install the Extension Packages
    environment.systemPackages = with pkgs; [
      gnome-extension-manager
      gnomeExtensions.forge
      gnomeExtensions.hide-top-bar
      gnomeExtensions.simpleweather
    ];

    home-manager.users.youhan = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };

        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "forge@jmmaranan.com"
            "hidetopbar@mathieu.bidon.ca"
            "simple-weather@romanlefler.com"
          ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          maximize = [];
          unmaximize = [];
        };
        "org/gnome/mutter/keybindings" = {
          toggle-tiled-left = [];
          toggle-tiled-right = [];
        };
        
        "org/gnome/shell/extensions/forge" = {
          tiling-mode-enabled = true;
          window-gap-size = 8;
          window-gap-hidden-on-single = true;
          
          focus-border-toggle = true;
          focus-border-color = hm.gvariant.mkTuple [ true 0.682 0.733 1.0 1.0 ];
          focus-border-size = 2; 
        };

        "org/gnome/shell/extensions/forge/keybindings" = {
          window-focus-left = ["<Super>Left"];
          window-focus-right = ["<Super>Right"];
          window-focus-up = ["<Super>Up"];
          window-focus-down = ["<Super>Down"];

          window-swap-left = ["<Shift><Super>Left"];
          window-swap-right = ["<Shift><Super>Right"];
          window-swap-up = ["<Shift><Super>Up"];
          window-swap-down = ["<Shift><Super>Down"];
        };

        "org/gnome/shell/extensions/hidetopbar" = {
          mouse-sensitive = true;
          enable-active-window-hints = true;
        };
      };
    };
    
    environment.sessionVariables = {
      TERMINAL = "kitty";
    };
  };
}