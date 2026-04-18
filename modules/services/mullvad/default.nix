{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.mullvad;
in {
  options.modules.services.mullvad = {
    enable = mkEnableOption "Mullvad VPN";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;

    environment.systemPackages = with pkgs; [
      mullvad-vpn # GUI app
      mullvad     # cli tool
    ];
  };
}