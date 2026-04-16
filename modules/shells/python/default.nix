{ pkgs }:

let
  python-fhs-env = pkgs.buildFHSEnv {
    name = "python-fhs";
    targetPkgs = pkgs: with pkgs; [
      uv
      python3
      python3Packages.pip
      pkg-config
      binutils
      gcc
      stdenv.cc.cc.lib
      glibc
      zlib
      libffi
      openssl
      cudaPackages.cudatoolkit
      linuxPackages.nvidia_x11
      libGL
      libGLU
      xorg.libX11
    ];

    multiPkgs = pkgs: with pkgs; [
      zlib
    ];
    
    profile = ''
      export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH"
      export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export PS1="(python-fhs) \w -> "
    '';
    
    runScript = "bash --login";
  };
in

pkgs.writeShellScriptBin "pyshell" ''
  exec ${python-fhs-env}/bin/python-fhs "$@"
''