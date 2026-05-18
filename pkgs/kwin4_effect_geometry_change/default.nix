{ fetchFromGitHub
, stdenvNoCC
, gnumake
}:

stdenvNoCC.mkDerivation {
  pname = "kwin4_effect_geometry_change";
  version = "v1.5";
  src = fetchFromGitHub {
    repo = "kwin4_effect_geometry_change";
    owner = "peterfajdiga";
    rev = "398491e8a3f5b9bb785850439abd41820f3c5986";
    hash = "sha256-pa3lHSZ2FtxCh9hyE+3PyV/q/moe15cE3wO0aQEH2vA=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kwin/effects/kwin4_effect_geometry_change
    cp -r package/* $out/share/kwin/effects/kwin4_effect_geometry_change
  '';

  format = "other";

  nativeBuildInputs = [
    gnumake
  ];
}