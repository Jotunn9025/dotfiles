{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.calibre;
in {
  options.apps.calibre = {
    enable = lib.mkEnableOption "Calibre Ebook Reader";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.calibre
    ];
  };
}