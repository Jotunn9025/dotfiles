{ config, lib, ... }:

with lib;
let cfg = config.system.hardware.audio;
in {
  options.system.hardware.audio = {
    enable = mkEnableOption "Pipewire Audio Support";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}