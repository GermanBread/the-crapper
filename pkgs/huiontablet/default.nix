# What in the actual fuck?!?!?!
# WHO WROTE THIS DRIVER?
# Why would any sane software/package:
# 1. Make EVERYTHING mode 0777
# 2. Make only some installation files owned by root
# 3. Store the user config in the same directory as the binary???? Do they not know what a HOME DIRECTORY is?!
# Just ... WHYY???

# Tested with Huion Kamvas 13 (Gen 3)
# Status: functional
# I highly suggest importing the kwin rules from the repo's toplevel `/files` directory

{ autoPatchelfHook
, stdenvNoCC
, fetchzip

# wrapper script deps
, runCommandNoCC
, kdePackages
, xmodmap
, ffmpeg
, xprop
, lib

, addDriverRunpath
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

, screenshotScaleFactor ? "1/4"
, alterKdeConfig ? true
, autostart ? true
}: let
  inherit (lib)
    optionalString
    makeBinPath
    ;
  driverPkg = stdenvNoCC.mkDerivation rec {
    pname = "HuionTablet";
    version = "v15.0.0.175";
    src = fetchzip {
      url = "https://driverdl.huion.com/driver/Linux/${pname}_LinuxDriver_${version}.${stdenvNoCC.hostPlatform.uname.processor}.tar.xz";
      hash = "sha256-VARRHkTncfzdzIMSeBF/RUkcP6mI0qf0JBLy9WkWKbI=";
      stripRoot = false;
    };
    buildInputs = [
      addDriverRunpath
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

      mkdir -p $out/{bin,etc/xdg,share,lib/udev}

      cp -r $src/huion/icon $out/share/icons

      cp -r $src/huion/xdg/autostart $out/share/applications
      # both files are identical
      # this probably isn't an effective space-saving measure
      # but I like it this way
      ${optionalString autostart "ln -s $out/share/applications $out/etc/xdg/autostart"}

      ${optionalString alterKdeConfig ''
        ln -s ${./kcminputrc} $out/etc/xdg/kcminputrc
        ln -s ${./kwinrc} $out/etc/xdg/kwinrc
      ''}

      cp -r $src/huion/huiontablet $out/lib/huiontablet
      cp -r $src/huion/huiontablet/res/rule $out/lib/udev/rules.d

      substituteInPlace $out/share/applications/huiontablet.desktop \
        --replace-fail /usr $out

      addAutoPatchelfSearchPath $out/lib/huiontablet/libs
      addAutoPatchelfSearchPath $out/lib/huiontablet/xdotool

      # breaks `w`, needed for tty detection...
      chmod 777 $out/lib/huiontablet/libs
      rm $out/lib/huiontablet/libs/libsystemd.so.0

      chmod 755 $out/lib/huiontablet
      substitute ${./huiontablet.sh} $out/lib/huiontablet/huiontablet.sh \
        --subst-var-by src $out \
        --subst-var-by extras ${makeBinPath [ ffmpeg xmodmap xprop ]} \
        --subst-var-by ffmpegScaleArg ${screenshotScaleFactor}
      chmod 755 $out/lib/huiontablet/huiontablet.sh
      ln -s $out/lib/huiontablet/huiontablet.sh $out/bin/huiontablet

      runHook postInstall
    '';
  };
in driverPkg