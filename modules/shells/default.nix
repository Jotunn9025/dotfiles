{
  imports = [
    ./nodejs
    ./python
    ./r
  ];

  system.shells.nodejs.enable = false;
  system.shells.python.enable = true;
  system.shells.r.enable = true; 
}