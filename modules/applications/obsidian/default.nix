{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.obsidian;
in {
  options.apps.obsidian = {
    enable = mkEnableOption "Obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.obsidian
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}