{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/applications
    ./modules/hardware
    ./modules/system
    ./modules/packages.nix
    ./modules/services
    ./modules/shells
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time and Locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN"; LC_IDENTIFICATION = "en_IN"; LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN"; LC_NAME = "en_IN"; LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN"; LC_TELEPHONE = "en_IN"; LC_TIME = "en_IN";
  };

  # User Account
  users.users.youhan = {
    isNormalUser = true;
    description = "Youhan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ pkgs.gedit ];
  };

  home-manager.users.youhan = {
    home.stateVersion = "25.11";
    programs.bash.enable = true;
    programs.home-manager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; 
}