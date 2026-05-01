{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.google-chrome;
in {
  options.apps.google-chrome = {
    enable = mkEnableOption "Google Chrome Browser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.google-chrome ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

  };
}