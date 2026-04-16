{
  imports = [
    ./desktop
    ./networking
  ];

  system.desktop.enable = true;
  system.networking.enable = true;
  system.networking.hostName = "nixos";
  environment.variables = {
    BROWSER = "firefox";
  };
}