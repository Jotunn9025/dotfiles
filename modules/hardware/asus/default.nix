{ config, lib, pkgs, inputs, ... }:

with lib;
let 
  cfg = config.system.hardware.asus;
in {
  options.system.hardware.asus = {
    enable = mkEnableOption "Asus Linux config";
  };

  imports = [
    inputs.nixos-hardware.nixosModules.asus-fa507nv
  ];

  config = mkIf cfg.enable {
    services.asusd = {
      enable = true;
    };

    services.supergfxd.enable = true;
    programs.rog-control-center.enable = true;
  };
}