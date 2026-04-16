{ pkgs }:

let
  dev-tools = with pkgs; [
    nodejs_22
    corepack
    typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    bun
    watchman
  ];
in
pkgs.writeShellScriptBin "nodeshell" ''
  export PATH="${pkgs.lib.makeBinPath dev-tools}:$PATH"
  
  export NPM_CONFIG_PREFIX="$HOME/.npm-global"
  export PATH="$HOME/.npm-global/bin:$PATH"
  
  echo "Node: $(node -v)"
  
  exec bash --init-file <(echo '[ -f ~/.bashrc ] && source ~/.bashrc; export PS1="(node-dev) \\w -> "')
''