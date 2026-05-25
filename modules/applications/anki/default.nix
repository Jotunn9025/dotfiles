{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.apps.anki;
in {
  options.apps.anki = {
    enable = mkEnableOption "Anki Flashcards";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.anki
    ];
environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
    };
  };
}