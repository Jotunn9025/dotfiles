{ config, lib, pkgs, ... }:

let
  cfg = config.system.shells.python;

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
      libavif
      libavif.dev
      openssl
      cudaPackages.cudatoolkit
      cudaPackages.cudnn
      cudaPackages.libcublas
      cudaPackages.libcusparse
      cudaPackages.libcusolver
      linuxPackages.nvidia_x11
      libGL
      libGLU
      libX11
      cairo
      cairo.dev        
      libXrender
      libXext
      libxcb
      mesa
      pkg-config
      freetype
      libpng
      libxcb.dev
      xcbutilrenderutil
      xcbutilrenderutil.dev
      libX11.dev
      glib
      libsecret
      libuuid
      e2fsprogs
      atk
      at-spi2-atk
      libXcursor
      libXinerama
      libXi
    ];

    multiPkgs = pkgs: with pkgs; [
      zlib
    ];
    
    profile = ''
      export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH"
      export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
      export CPATH="${pkgs.libX11.dev}/include:${pkgs.xorgproto}/include:$CPATH"
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.cairo.dev}/lib/pkgconfig:${pkgs.libpng.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
      export LD_PRELOAD="${pkgs.gperftools}/lib/libtcmalloc.so"
      export PS1="(python-fhs) \w -> "
    '';
    
    runScript = "bash --login";
  };

  pyshell = pkgs.writeShellScriptBin "pyshell" ''
    exec ${python-fhs-env}/bin/python-fhs "$@"
  '';
in {
  options.system.shells.python = {
    enable = lib.mkEnableOption "Python FHS Environment Shell";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pyshell ];
  };
}