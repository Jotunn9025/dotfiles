{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.xournal;
in {
  options.apps.xournal = {
    enable = mkEnableOption "Xournal++";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.xournalpp
    ];
  };
}