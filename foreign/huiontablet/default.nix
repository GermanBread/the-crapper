# What in the actual fuck?!?!?!
# WHO WROTE THIS DRIVER?
# Why would any sane software/package:
# 1. Make EVERYTHING mode 0777
# 2. Make only some installation files owned by root
# 3. Store the user config in the same directory as the binary???? Do they not know what a HOME DIRECTORY is?!
# Just ... WHYY???

# Tested with Huion Kamvas 13 (Gen 3)
# Status: launches, settings can be changed but they don't persist, stylus is picked up, tilt probably works
# Problems: many, too many
# Solutions: https://github.com/containers/bubblewrap/pull/547 ?

# I know this driver works in general, I tested it on Arch Linux.
# I had to boot into Plasma's X11 session and after going back to Wayland I could map the tablet area on Wayland.
# Unless Krita's being weird, the default wheel bindings don't work-ish (only enlarge brush does something and it zooms in the canvas)
# I highly suggest importing the kwin rules from the repo's toplevel `/files` directory

{ autoPatchelfHook
, stdenvNoCC
, fetchzip

, libgpg-error
, libxinerama
, libsForQt5
, fontconfig
, e2fsprogs
, libxrandr
, freetype
, libusb1
, libxtst
, libX11
, libgcc
, libGL
}:

stdenvNoCC.mkDerivation rec {
  pname = "HuionTablet";
  version = "v15.0.0.175";
  src = fetchzip {
    url = "https://driverdl.huion.com/driver/Linux/${pname}_LinuxDriver_${version}.${stdenvNoCC.hostPlatform.uname.processor}.tar.xz";
    hash = "sha256-VARRHkTncfzdzIMSeBF/RUkcP6mI0qf0JBLy9WkWKbI=";
    stripRoot = false;
  };
  buildInputs = [
    fontconfig.lib
    libgpg-error
    libxinerama
    libgcc.lib
    e2fsprogs
    libxrandr
    freetype
    libxtst
    libusb1
    libX11
    libGL
  ];
  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    autoPatchelfHook
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{etc/xdg,share,lib/udev}

    cp -r $src/huion/icon $out/share/icons

    cp -r $src/huion/xdg/autostart $out/share/applications
    # both files are identical
    # this probably isn't an effective space-saving measure
    # but I like it this way
    ln -s $out/share/applications $out/etc/xdg/autostart

    cp -r $src/huion/huiontablet $out/lib/huiontablet
    cp -r $src/huion/huiontablet/res/rule $out/lib/udev/rules.d

    substituteInPlace $out/share/applications/huiontablet.desktop \
      --replace-fail /usr $out

    addAutoPatchelfSearchPath $out/lib/huiontablet/libs
    addAutoPatchelfSearchPath $out/lib/huiontablet/xdotool

    # breaks `w`, needed for tty detection...
    chmod 777 $out/lib/huiontablet/libs
    rm $out/lib/huiontablet/libs/libsystemd.so.0

    runHook postInstall
  '';
}