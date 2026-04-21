{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktop
    ./networking
  ];

  system.desktop.enable = true;
  system.networking.enable = true;
  system.networking.hostName = "nixos";
  
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