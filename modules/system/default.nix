{ config, lib, pkgs, ... }:

let
  pyshell   = import ../shells/python/default.nix { inherit pkgs; };
  nodeshell = import ../shells/nodejs/default.nix { inherit pkgs; };
in
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

  environment.systemPackages = [
    pyshell
    nodeshell
  ];
}