{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.todoist;
in {
  options.apps.todoist = {
    enable = lib.mkEnableOption "Todoist Desktop App";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.todoist-electron
    ];
  };
}