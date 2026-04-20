{
  imports = [
    ./audio
    ./nvidia
    ./asus
    ./swap
    ./drives
  ];

  system.hardware.audio.enable = true;
  system.hardware.nvidia.enable = true; 
  system.hardware.asus.enable = true;
  system.hardware.swap.enable = true;
  system.hardware.drives.enable = true;
}