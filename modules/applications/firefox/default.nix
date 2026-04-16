{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.firefox;
in {
  options.apps.firefox = {
    enable = mkEnableOption "Firefox Browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.youhan = {
      programs.firefox = {
        enable = true;
        
        policies = {
          ExtensionSettings = {
            # uBlock Origin
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
            
            # Bitwarden
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              installation_mode = "force_installed";
            };
            
            # Privacy Badger
            "jid1-MnnxcxisBPnSXQ@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        };

        profiles.youhan = {
          isDefault = true;
          settings = {
            "browser.startup.page" = 3; 
            "browser.aboutConfig.showWarning" = false; 
            "browser.theme.content-theme" = 0; 
            "privacy.trackingprotection.enabled" = true;
            "dom.security.https_only_mode" = true;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "extensions.pocket.enabled" = false;
          };
        };
      };
    };
  };
}