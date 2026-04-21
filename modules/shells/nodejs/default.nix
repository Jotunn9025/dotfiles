{ config, lib, pkgs, ... }:

let
  cfg = config.system.shells.nodejs;

  dev-tools = with pkgs; [
    nodejs_22
    corepack
    typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    bun
    watchman
  ];

  nodeshell = pkgs.writeShellScriptBin "nodeshell" ''
    export PATH="${pkgs.lib.makeBinPath dev-tools}:$PATH"
    
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="$HOME/.npm-global/bin:$PATH"
    
    echo "Node: $(${pkgs.nodejs_22}/bin/node -v)"
    
    exec bash --init-file <(echo '[ -f ~/.bashrc ] && source ~/.bashrc; export PS1="(node-dev) \\w -> "')
  '';
in {
  options.system.shells.nodejs = {
    enable = lib.mkEnableOption "NodeJS Development Shell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ nodeshell ];
  };
}