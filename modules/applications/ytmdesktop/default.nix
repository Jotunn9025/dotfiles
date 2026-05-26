{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.ytmdesktop;
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

    systemd.services.install-flatpak-ytm = {
      description = "Install YouTube Music Flatpak";
      
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Environment = "PATH=/run/current-system/sw/bin";
        ExecStart = pkgs.writeShellScript "install-ytm" ''
          ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
          ${pkgs.flatpak}/bin/flatpak install -y flathub app.ytmdesktop.ytmdesktop
        '';
      };
    };
  };
}