{ pkgs, autoPatchelfHook, ... }:

let
  fhspkgs = with pkgs; [
    # Video
    xorg.xrandr
    xorg.libXext xorg.libX11 xorg.libXrender xorg.libXtst xorg.libXi xorg.libxcb xorg.libXdamage xorg.libxshmfence xorg.libXxf86vm xorg.libXinerama xorg.libXdamage xorg.libXcursor xorg.libXrender xorg.libXScrnSaver xorg.libXxf86vm xorg.libXi xorg.libSM xorg.libICE xorg.libXt xorg.libXmu xorg.libxcb
    udev libGL libva libvdpau
    mesa.drivers expat wayland libelf

    # Font rendering
    freetype fontconfig gdk-pixbuf dejavu_fonts source-code-pro
    
    # Audio
    alsaUtils pipewire pipewire.pulse
    alsaLib alsaPlugins pipewire.lib pipewire.lib.pulse
    
    # Video
    glib
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-ugly gst_all_1.gst-plugins-bad gst_all_1.gst-libav
    libsForQt5.qtbase libsForQt5.qtx11extras libsForQt5.phonon-backend-gstreamer
    
    # Misc
    xdg-utils iana-etc lsb-release pciutils which
    zlib libcap rtkit
    dbus xdg-utils xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-kde xdg-desktop-portal-wlr

    # Override
    pipewire-alsa-conf
  ];

  pipewire-alsa-conf = pkgs.stdenv.mkDerivation {
    name = "pipewire-alsa-conf";
    buildCommand = ''
      mkdir -p $out/etc/alsa/conf.d
      ln -sf /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf $out/etc/alsa/conf.d/99-pipewire-default.conf
    '';
  };

  fhsenv = (pkgs.buildFHSUserEnv {
    name = "fhs-chroot";
    targetPkgs = pkgs: (fhspkgs);
    multiPkgs  = pkgs: (fhspkgs);
  });

  processing = builtins.fetchTarball {
    url = "https://github.com/processing/processing4/releases/download/processing-1279-4.0b4/processing-4.0b4-linux-x64.tgz";
  };
in

(pkgs.stdenv.mkDerivation {
  name = "processing4";
  src = fhsenv;

  installPhase = ''
    scriptpath=$out/bin/processing4
    
    mkdir -p $out/bin
    mkdir -p $out/share/applications

    cp ${processing}/lib/desktop.template $out/share/applications/processing4.desktop
    sed -i "s,<BINARY_LOCATION>,$scriptpath,g" $out/share/applications/processing4.desktop
    
    sed -i "s,<ICON_NAME>,${processing}/lib/icons/pde-1024.png,g" $out/share/applications/processing4.desktop

    cat << EOF > $scriptpath
    #!${pkgs.bash}/bin/bash
    exec ${fhsenv.outPath}/bin/${fhsenv.name} ${processing}/processing
    EOF
    chmod +x $scriptpath
  '';
}).out
