{
  imports = [
    ./nodejs
    ./python
    ./r
  ];

  system.shells.nodejs.enable = true;
  system.shells.python.enable = true;
  system.shells.r.enable = false; 
}