{ config, lib, pkgs, ... }:

let
  cfg = config.system.shells.r;

  # Bundle R with all necessary libraries
  my-r = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      ggplot2          
      dplyr            
      forecast         
      tseries          
      languageserver   
      # httpgd apparently broken upstream rn           
      jsonlite
      rlang
    ];
  };

  rshell = pkgs.writeShellScriptBin "rshell" ''
    export PATH="${pkgs.lib.makeBinPath [ my-r ]}:$PATH"
    
    echo "Loaded R Env"
    
    exec bash --init-file <(echo '[ -f ~/.bashrc ] && source ~/.bashrc; export PS1="(r-dev) \\w -> "')
  '';
in {
  options.system.shells.r = {
    enable = lib.mkEnableOption "R Data Science Shell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ rshell ];
  };
}