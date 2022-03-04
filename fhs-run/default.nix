{ pkgs, extraPkgs ? pkgs: [], ... }:

let
  fhspkgs = with pkgs; [
    # Yeeted from steam-run
    lsb-release pciutils python2 which perl xdg-utils iana-etc python3 procps usbutils sqlite libva pipewire.lib pango at-spi2-atk at-spi2-core gst_all_1.gstreamer gst_all_1.gst-plugins-ugly gst_all_1.gst-plugins-base json-glib libdrm libxkbcommon mono udev dbus zlib zettlr glib atk cairo fontconfig lsof file libGLU libuuid libbsd alsa-lib libidn2 libpsl nghttp2.lib openssl_1_1 rtmpdump libcap expat libelf bzip2 zlib gdk-pixbuf curl nspr nss cairo expat dbus cups libcap libusb1 dbus-glib ffmpeg atk libudev0-shim networkmanager098 libogg libvorbis libidn tbb flac freeglut libjpeg libpng12 libsamplerate libmikmod libtheora libtiff pixman speex libcaca libcanberra libgcrypt libvpx librsvg libvdpau
    
    icu
    krb5
    ncurses
    appimage-run # Might not work?
  ] ++ extraPkgs pkgs;

  fhsenv = (pkgs.buildFHSUserEnv {
    name = "fhs-run-chroot";
    targetPkgs = pkgs: (fhspkgs);
  });
in

(pkgs.stdenv.mkDerivation {
  name = "fhs-run";
  src = fhsenv;
  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin

    cat << EOF > $out/lib/rc
    export PS1="[FHS-ENV (\u) \W]: "
    export COLORTERM=truecolor
    EOF
    
    cat << EOF > $out/bin/fhs-run
    #!${pkgs.bash}/bin/bash
    [ \$# -eq 0 ] && echo 'fhs-run [...args]' && exit 1
    exec ${fhsenv.outPath}/bin/${fhsenv.name} -c "source $out/lib/rc && \"\$@\""
    EOF
    chmod +x $out/bin/fhs-run
  '';
}).out