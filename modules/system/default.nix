{ config, lib, pkgs, ... }:

let
  python-fhs-env = import ../shells/python/default.nix { inherit pkgs; };
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
    python-fhs-env
   (pkgs.writeShellScriptBin "pyshell" ''
      exec ${python-fhs-env}/bin/python-fhs "$@"
    '')
  ];
}