{ config, lib, pkgs, inputs, ... }:
with lib;
let 
  cfg = config.system.desktop;
  hm = inputs.home-manager.lib.hm;
in {
  options.system.desktop = {
    enable = mkEnableOption "GNOME Desktop Environment, Wayland, and Printing";
  };
  config = mkIf cfg.enable {
    # Wayland & Keymap
    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
    # GNOME Desktop
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    services.desktopManager.gnome.enable = true;
    # Printing
    services.printing.enable = true;
    # System Packages
    environment.systemPackages = with pkgs; [
      gnome-extension-manager
      gnomeExtensions.forge
      gnomeExtensions.hide-top-bar
      gnomeExtensions.simpleweather
    ];
    # System Variables
    environment.sessionVariables = {
      TERMINAL = "kitty";
    };
    # Home Manager Settings
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
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          workspaces-only-on-primary = true;
        };
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 10;
        };
        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-up    = [];
          switch-to-workspace-down  = [];
          switch-to-workspace-left  = [ "<Control><Super>Left" ];
          switch-to-workspace-right = [ "<Control><Super>Right" ];
          move-to-workspace-up      = [];
          move-to-workspace-down    = [];
          move-to-workspace-left    = [ "<Control><Shift><Super>Left" ];
          move-to-workspace-right   = [ "<Control><Shift><Super>Right" ];
          maximize   = [];
          unmaximize = [];
        };
        # Forge Configuration
        "org/gnome/shell/extensions/forge" = {
          tiling-mode-enabled         = true;
          window-gap-size             = 8;
          window-gap-hidden-on-single = true;
          focus-border-toggle         = true;
          focus-border-color = hm.gvariant.mkTuple [ true 0.682 0.733 1.0 1.0 ];
        };
        "org/gnome/shell/extensions/forge/keybindings" = {
          window-focus-left  = [ "<Super><Alt>Left" ];
          window-focus-right = [ "<Super><Alt>Right" ];
          window-focus-up    = [ "<Super><Alt>Up" ];
          window-focus-down  = [ "<Super><Alt>Down" ];
          window-swap-left   = [ "<Shift><Super>Left" ];
          window-swap-right  = [ "<Shift><Super>Right" ];
          window-swap-up     = [ "<Shift><Super>Up" ];
          window-swap-down   = [ "<Shift><Super>Down" ];
          window-toggle-float = [ "<Super>t" ];
        };
        "org/gnome/mutter/keybindings" = {
          toggle-tiled-left  = [];
          toggle-tiled-right = [];
        };
        "org/gnome/shell/extensions/hidetopbar" = {
          mouse-sensitive            = true;
          enable-active-window-hints = true;
        };
      };
    };
  };
}