{ config, lib, ... }:

with lib;
let 
  cfg = config.system.hardware.swap;
in {
  options.system.hardware.swap = {
    enable = mkEnableOption "8GB Swap File";
  };

  config = mkIf cfg.enable {
    swapDevices = [ {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8GB 
    } ];
  };
}