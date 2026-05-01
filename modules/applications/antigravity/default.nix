{ config, lib, pkgs, inputs, ... }:

let 
  cfg = config.apps.antigravity;
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  options.apps.antigravity = {
    enable = lib.mkEnableOption "antigravity";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      unstable.antigravity-fhs
    ];
  };
}