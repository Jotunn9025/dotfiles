{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps."easy-effects"; 
in {
  options.apps."easy-effects" = {
    enable = mkEnableOption "EasyEffects Audio Processor";
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    home-manager.users.youhan = {
      services.easyeffects.enable = true;
      
      home.packages = [ pkgs.easyeffects ];
    };
  };
}