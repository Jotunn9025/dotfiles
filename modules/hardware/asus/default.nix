{ config, lib, ... }:

with lib;
let cfg = config.system.hardware.asus;
in {
  options.system.hardware.asus = {
    enable = mkEnableOption "Asus-Linux tools and daemons";
  };

  config = mkIf cfg.enable {
    services.asusd = {
      enable = true;
      enableUserService = true;
    };

    services.supergfxd.enable = true;

    programs.rog-control-center.enable = true;
  };
}