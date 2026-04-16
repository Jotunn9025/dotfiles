{ config, lib, ... }:

with lib;
let cfg = config.system.networking;
in {
  options.system.networking = {
    enable = mkEnableOption "NetworkManager and networking";
    hostName = mkOption {
      type = types.str;
      default = "nixos";
    };
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostName;
    networking.networkmanager.enable = true;
  };
}