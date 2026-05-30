{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.foundryvtt;
in {
  options.apps.foundryvtt = {
    enable = mkEnableOption "Foundry VTT Container Service";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers.foundryvtt = {
      image = "ghcr.io/felddy/foundryvtt:13"; 
      hostname = "nixos-foundry-host";       
      ports = [ "30000:30000" ];             
      volumes = [
        "/var/lib/foundryvtt:/data"          
      ];
      
      environmentFiles = [
        "/home/youhan/dotfiles/secrets/foundry.token"
      ];

      environment = {
        FOUNDRY_TELEMETRY = "false";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/foundryvtt 0770 root docker -"
    ];
  };
}