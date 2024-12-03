{ pkgs, lib, stdenv, fetchFromGitHub, qt5 }:

stdenv.mkDerivation rec {
  name = "wallpaper-engine-kde-plugin";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = "8f167c34ac82b00eb542a6597c60ec13d03b69ce";
    sha256 = "sha256-hIrZTeijTJGcbQaykAfOlb12I4m3BPTDmCKxWaz2q0Q=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with pkgs; [
    cmake extra-cmake-modules
    
    glslang shaderc
    libass fribidi
    # mpv deps
    alsa-lib libarchive libbluray libbs2b libcaca lcms2 libdvdnav libjack2 mujs libpng openalSoft libpulseaudio pipewire rubberband SDL2 libsixel speex swift libtheora libva vapoursynth libvdpau zimg
    lz4.dev libGL libGLU vulkan-headers vulkan-loader
    freeglut wayland
    wayland-protocols
  ] ++ (with pkgs.xorg; [
    libXScrnSaver libXinerama libXv
  ]) ++ [
    qt5.wrapQtAppsHook
  ];
  buildInputs = with pkgs; [ mpv ffmpeg ]
    ++ (with pkgs.xorg; [ libX11 libXext ])
    ++ (with pkgs.plasma5Packages; [ plasma-framework ])
    ++ (with pkgs.libsForQt5; [ qtbase qtdeclarative qtwebsockets qtwebchannel qtx11extras ])
    ++ (with pkgs.python38Packages; [ websockets ]);

  # dontWrapQtApps = true;

  meta = with lib; {
    description = "Wallpaper Engine KDE plasma plugin";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}