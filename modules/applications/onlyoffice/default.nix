{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.onlyoffice;
in {
  options.apps.onlyoffice = {
    enable = lib.mkEnableOption "OnlyOffice";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      onlyoffice-desktopeditors
      corefonts   
      vista-fonts  
    ];
  };
}