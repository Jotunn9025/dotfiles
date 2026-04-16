{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.easyeffects;
in {
  options.apps.easyeffects = {
    enable = mkEnableOption "EasyEffects Audio Processor";
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    home-manager.users.youhan = {
      services.easyeffects = {
        enable = true;
        autoStart = true;
      };
    };
  };
}