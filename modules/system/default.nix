{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktop
    ./networking
    ./bluetooth
  ];

  system.desktop.enable = true;
  system.networking.enable = true;
  system.networking.hostName = "nixos";
  system.bluetooth.enable = true;
  environment.variables = {
    BROWSER = "firefox";
  };
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
}