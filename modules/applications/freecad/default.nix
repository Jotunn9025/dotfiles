{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.freecad;
in {
  options.apps.freecad = {
    enable = lib.mkEnableOption "FreeCAD";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      freecad
    ];
  };
}