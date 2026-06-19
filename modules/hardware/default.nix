{
  imports = [
    ./audio
    ./nvidia
    ./asus
    ./swap
    ./drives
  ];

  boot.kernelModules = [ "hid_logitech_hidpp" ];

  system.hardware.audio.enable = true;
  system.hardware.nvidia.enable = true; 
  system.hardware.asus.enable = true;
  system.hardware.swap.enable = true;
  system.hardware.drives.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
}