{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  name = "fmlock";
  owner = "datenwolf";

  src = pkgs.fetchFromGitHub {
    inherit owner;
    repo = name;
    rev = "61d46cbf110d5c73345c3d6d8dff0a11b4a58b2b";
    sha256 = "sha256-IAJPN9R6p4GjWfIJLL2Znkff0K1FLMvBetPdXD90gr0=";
  };

  buildPhase = ''
    make
    strip fmlock
  '';
  installPhase = ''
    mkdir -p $out/bin
    install -m555 fmlock $out/bin/fmlock
  '';
}