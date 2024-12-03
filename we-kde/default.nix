
{ pkgs, lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "wallpaper-engine-kde-plugin";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = "v${version}";
    sha256 = "sha256-VMOUNtAURTHDuJBOGz2N0+3VzxBmVNC1O8dVuyUZAa4=";
  };

  postPatch = "rm build";
  nativeBuildInputs = with pkgs; [ cmake extra-cmake-modules gnumake ];
  buildInputs = with pkgs; [ plasma5Packages.plasma-framework mpv python38Packages.websockets vulkan-headers ];

  preparePhase = ''
    ls
    exit 1
    
    mkdir build
    cd build
    cmake ..
  '';
  buildPhase = ''
    make -j$nproc
  '';
  installPhase = ''
    make DESTDIR=$out install
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Wallpaper Engine KDE plasma plugin";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}