{ config, lib, pkgs, inputs, ... }:

let 
  cfg = config.apps.lutris;
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  options.apps.lutris = {
    enable = lib.mkEnableOption "Lutris";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      unstable.lutris 
      
      pkgs.wineWowPackages.stable
      pkgs.winetricks
      pkgs.vulkan-tools
    ];
  };
}