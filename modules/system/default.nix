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
  
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "pyshell" ''
      exec nix run /home/youhan/dotfiles#python --impure "$@"
    '')
  ];
}