{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.apps.discord;
in {
  options.apps.discord = {
    enable = mkEnableOption "Discord (with Wayland/Vencord fixes)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (discord.override {
        withOpenASAR = true; 
        withVencord = true;  
      })
    ];
  };
}