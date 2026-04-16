{ config, lib, pkgs, ... }:

with lib;
let cfg = config.apps.vscode;
in {
  options.apps.vscode = {
    enable = mkEnableOption "VSCode Editor";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.vscode ];

    home-manager.users.youhan = {
      home.sessionVariables = {
        EDITOR = "code --wait";
        VISUAL = "code --wait";
      };
    };
  };
}