{ config, pkgs, ... }:

{
  home.username = "youhan";
  home.homeDirectory = "/home/youhan";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    vscode
    fastfetch
    btop
    tree
    wget
    curl

    #extract/compressing stuff
    unzip
    zip
    rar
    p7zip
  ];

  programs.bash = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jotunn9025";
        email = "youhanlalwani@gmail.com";
      };
      init.defaultBranch = "main";
      core.editor = "code --wait";
    };
  };

  home.sessionVariables = {
    EDITOR = "code --wait";
    VISUAL = "code --wait";
  };

  programs.home-manager.enable = true;
}
