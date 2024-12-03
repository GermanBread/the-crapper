{ lib, stdenv
, fetchFromGitHub

, cmake
, ninja
, gettext
, wrapGAppsHook
, wrapQtAppsHook
, pkg-config

, glib
, gsettings-desktop-schemas
, gtk3
, librsvg
, libsndfile
, libxml2
, libzip
, pcre
, poppler
, portaudio
, zlib
# plugins
, withLua ? true, lua

# fixes crashes and theme issues
, gnome
, breeze-qt5
, breeze-gtk
, withPortal ? true, xdg-desktop-portal, xdg-desktop-portal-kde, xdg-desktop-portal-wlr, xdg-desktop-portal-gnome, xdg-desktop-portal-gtk
}:

stdenv.mkDerivation rec {
  pname = "xournalpp";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AzLkXGcTjtfBaPOZ/Tc+TwL63vm08G2tZw3pGzoo7po=";
  };

  nativeBuildInputs = [ cmake ninja gettext pkg-config wrapGAppsHook wrapQtAppsHook ];
  buildInputs =
    [ glib
      gsettings-desktop-schemas
      gtk3
      librsvg
      libsndfile
      libxml2
      libzip
      pcre
      poppler
      portaudio
      zlib
      
      gnome.adwaita-icon-theme
      breeze-gtk breeze-qt5
    ]
    ++ lib.optional withLua [ lua ]
    ++ lib.optional withPortal [
      xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-wlr xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    ];

  
  buildFlags = "translations";

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = "https://xournalpp.github.io/";
    changelog   = "https://github.com/xournalpp/xournalpp/blob/v${version}/CHANGELOG.md";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ andrew-d sikmir ];
    platforms   = platforms.linux;
  };
}
