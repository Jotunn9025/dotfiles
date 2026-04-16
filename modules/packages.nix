{ pkgs, ... }:

{
  # System CLI tools
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];

  # User CLI tools 
  home-manager.users.youhan = {
    home.packages = with pkgs; [
      fastfetch
      btop
      tree
      unzip
      zip
      rar
      p7zip
    ];
  };
}