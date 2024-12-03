
{ pkgs, lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "wallpaper-engine-kde-plugin";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = "17ed549eee251043fc3962564daf5fce29fea952";
    sha256 = "a0iwxu/V6vNWftfjQE/mY0wO0lEtVIkQVNZypUT/fdI=";
  };

  nativeBuildInputs = with pkgs; [
    cmake extra-cmake-modules gnumake mesa

    mesa.libdrm mesa.osmesa lz4.dev glew libGLU
    freeglut glew libGL libGLU mesa mesa.osmesa wayland
    wayland-protocols
  ];
  buildInputs = with pkgs; [ mpv vulkan-headers ]
    ++ (with pkgs.xorg; [ libX11 libXext ])
    ++ (with pkgs.plasma5Packages;[ plasma-framework ])
    ++ (with pkgs.libsForQt5;[ qtbase qtdeclarative qtwebsockets qtwebchannel qtx11extras ])
    ++ (with pkgs.python38Packages; [ websockets ]);

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Wallpaper Engine KDE plasma plugin";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}