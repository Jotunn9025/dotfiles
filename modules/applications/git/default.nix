{ config, lib, ... }:

with lib;
let cfg = config.apps.git;
in {
  options.apps.git = {
    enable = mkEnableOption "Git version control";
  };

  config = mkIf cfg.enable {
    home-manager.users.youhan = {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Jotunn9025";
            email = "youhanlalwani@gmail.com";
          };
          init.defaultBranch = "main";
          core.editor = "code --wait";
        };
      };
    };
  };
}