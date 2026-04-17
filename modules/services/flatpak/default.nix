{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.flatpak;
in {
  options.modules.services.flatpak = {
    enable = mkEnableOption "Flatpak Support";
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    environment.extraInit = ''
      export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
    '';

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}