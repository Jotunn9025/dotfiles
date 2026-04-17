{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale = {
    enable = mkEnableOption "Tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    
    services.tailscale.useRoutingFeatures = "both";

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ]; 

      allowedTCPPorts = [ 
        25565 # Minecraft 
        30000 # Foundry vtt
      ];

      allowedUDPPorts = [ 
        config.services.tailscale.port # Official Tailscale port
        25565                          # Minecraft
      ];

      checkReversePath = "loose";
    };
  };
}