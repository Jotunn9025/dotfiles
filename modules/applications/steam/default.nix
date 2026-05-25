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
      localNetworkGameTransfers.openFirewall = true;
    };

    hardware.steam-hardware.enable = true;
    hardware.graphics.enable32Bit = true;

    hardware.xpadneo.enable = true; 
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    '';

    environment.systemPackages = with pkgs; [
      protonup-ng
      # 2. Handy tool to test your buttons outside of a game
      gamepad-tool 
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}