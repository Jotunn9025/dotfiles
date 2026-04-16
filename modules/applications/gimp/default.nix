{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.apps.gimp;
in {
  options.apps.gimp = {
    enable = mkEnableOption "GIMP Image Editor";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp
    ];
  };
}