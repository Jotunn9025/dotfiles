{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.solaar; 
in {
  options.apps.solaar = {
    enable = mkEnableOption "Solaar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.solaar ];
    hardware.logitech.wireless.enable = true;
  };
}