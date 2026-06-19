{ config, lib, ... }:
with lib;
let cfg = config.system.bluetooth;
in {
  options.system.bluetooth = {
    enable = mkEnableOption "Bluetooth support";
  };
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.bluetooth.settings.General = {
      Experimental = true;
    };
  };
}