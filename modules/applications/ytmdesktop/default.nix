{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.ytmdesktop;
  # Check if your custom flatpak module switch is actually on
  flatpakEnabled = config.modules.services.flatpak.enable or false;
in {
  options.apps.ytmdesktop = {
    enable = mkEnableOption "YouTube Music (Flatpak)";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = flatpakEnabled;
        message = ''
          Enable Flatpak in modules/services/default.nix
        '';
      }
    ];

    system.activationScripts.flatpak-ytm = {
      text = ''
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        ${pkgs.flatpak}/bin/flatpak install -y flathub app.ytmdesktop.ytmdesktop
      '';
    };
  };
}