{ config, lib, ... }:

with lib;
let
  cfg = config.services.ssh;
in {
  options.services.ssh = {
    enable = mkEnableOption "Secure SSH Daemon";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;

      settings = {
        PermitRootLogin = "no";
        # 1. Disable passwords. Keys only!
        PasswordAuthentication = false; 
      };
    };

    users.users.youhan.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPajKc66vmIkgWXhTteGP5zRmk6TSLC2AqhjMj7PcYW6 youhan@oneplus"
    ];
  };
}