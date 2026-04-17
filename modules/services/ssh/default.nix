{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false; 
      };
    };

    users.users.youhan.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPajKc66vmIkgWXhTteGP5zRmk6TSLC2AqhjMj7PcYW5 youhan@oneplus"
    ];
  };
}