{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.minecraft;
in {
  options.apps.minecraft = {
    enable = lib.mkEnableOption "Prism Launcher (Minecraft)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      
      jdk17
      jdk21
    ];
  };
}