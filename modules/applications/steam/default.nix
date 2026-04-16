{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.steam;
in {
  options.apps.steam = {
    enable = mkEnableOption "Steam gaming platform with Proton-GE";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true; # Saves bandwidth!
    };

    hardware.steam-hardware.enable = true;
    hardware.graphics.enable32Bit = true;

    environment.systemPackages = with pkgs; [
      protonup-ng
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}