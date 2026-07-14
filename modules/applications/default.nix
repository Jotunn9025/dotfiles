{lib, ...}:
let 

  enabledApps = [
    "git"
    "vscode"
    "firefox"
    "steam"
    "easy-effects"
    "discord"
    "gimp"
    "ytmdesktop"
    "lutris"
    "onlyoffice"
    "minecraft"
    "todoist"
    "conky"
    "todo-cli"
    "obsidian"
    "foundryvtt"
    "antigravity"
    #"anki"
    #"calibre"
    "solaar"
    "xournal"
    "freecad"
    "orcaslicer"
  ];

  contents = builtins.readDir ./.;
  folders = lib.filterAttrs (name: type: type == "directory") contents;
  imports = builtins.map (name: ./. + "/${name}") (builtins.attrNames folders);
in
{
  imports = imports;
  apps = lib.genAttrs enabledApps (name: { enable = true; });
}