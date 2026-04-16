{
  imports = [
    ./audio
    ./nvidia
    ./asus
  ];

  system.hardware.audio.enable = true;
  system.hardware.nvidia.enable = true; 
  system.hardware.asus.enable = true;
}