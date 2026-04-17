{ config, lib, inputs, ... }:

with lib;
let cfg = config.system.hardware.nvidia;
in {
  imports = [ inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime ];

  options.system.hardware.nvidia = {
    enable = mkEnableOption "Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      
      open = false; 

      nvidiaSettings = true;
      
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}