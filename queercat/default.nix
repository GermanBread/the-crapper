{ pkgs, lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "queercat";
  owner = "a-weeb-programmer";

  src = fetchFromGitHub {
    inherit owner;
    repo = name;
    rev = "8e8790074e230edca86e4d4d4d962eb27fa0c2a9";
    sha256 = "sha256-iaRgVQEppYX5TzZUfvzO23fj0UZhX5xjoN3lo2fzmU8=";
  };

  buildPhase = ''
    gcc main.c -lm -o queercat
    strip queercat
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -m 555 queercat $out/bin/queercat
  '';
}