{ config, lib, pkgs, ... }:

let 
  cfg = config.system.hardware.drives;
in {
  options.system.hardware.drives = {
    enable = lib.mkEnableOption "Spare drives";
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /mnt/games 0755 youhan users"
    ];

    fileSystems."/mnt/games" = {
      device = "/dev/disk/by-uuid/b2fa5731-566a-4b14-bf9a-75404f8082e6";
      fsType = "ext4";
      options = [ 
        "defaults" 
        "nofail"         
        "x-gvfs-show"    
      ]; 
    };
  };
}