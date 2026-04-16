{ lib, ... }:

let
  enabledServices = [
    "ssh"
    "tailscale"
  ];

  contents = builtins.readDir ./.;
  folders = lib.filterAttrs (name: type: type == "directory") contents;
  imports = builtins.map (name: ./. + "/${name}") (builtins.attrNames folders);
in
{
  imports = imports;

  services = lib.genAttrs enabledServices (name: { enable = true; });
}