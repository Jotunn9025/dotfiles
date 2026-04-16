{ config, lib, inputs, ... }:

with lib;
let cfg = config.system.hardware.nvidia;
in {
  imports = [ inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime ];

  options.system.hardware.nvidia = {
    enable = mkEnableOption "Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}