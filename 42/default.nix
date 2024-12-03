{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "42.zip";
  dontUnpack = true;
  src = fetchurl {
    url = "https://github.com/iamtraction/ZOD/raw/master/42.zip";
    hash = "sha256-u9Bd4ZqirxRVwElGOSFYmKFShtmwUHO2xIF/4kssNvo=";
  };
  dontPatch = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    cp $src $out/42.zip
  '';
}