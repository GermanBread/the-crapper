{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "kurve";
  version = "v0.4.0";
  src = pkgs.fetchFromGitHub {
    repo = pname;
    owner = "luisbocanegra";
    rev = "d9c676430908f000ff2968e822af184dd51fabed";
    hash = "sha256-Ra+ySuvBqmVOTD8TlWDJklXYuwXPb/2a3BSY+gQMiiA=";
  };

  buildPhase = ''
    cmake -B build -S "$src" -DINSTALL_PLASMOID=ON -DBUILD_PLUGIN=ON
    cmake --build build
  '';
  installPhase = ''
    DESTDIR="$out" cmake --install build
  '';

  format = "other";

  buildInputs = with pkgs; [
    cava
    (python3.withPackages (ps: [ ps.websockets ]))
    qt6Packages.qtwebsockets
    qt6Packages.qtbase
    qt6.full
  ];
  nativeBuildInputs = with pkgs; [
    extra-cmake-modules cmake
    kdePackages.libplasma
    qt6Packages.wrapQtAppsHook
    qt6Packages.qtwebsockets.dev
    qt6Packages.qtbase.dev
  ];
}