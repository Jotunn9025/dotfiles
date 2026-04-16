{lib, ...}:
let 

  enabledApps = [
    "git"
    "vscode"
    "firefox"
    "steam"
    "easy-effects"
  ];

  contents = builtins.readDir ./.;
  folders = lib.filterAttrs (name: type: type == "directory") contents;
  imports = builtins.map (name: ./. + "/${name}") (builtins.attrNames folders);
in
{
  imports = imports;
  apps = lib.genAttrs enabledApps (name: { enable = true; });
}