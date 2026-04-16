{ config, lib, ... }:

with lib;
{
  config = mkIf config.services.tailscale.enable {
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