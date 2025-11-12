{
  pkgs,
  ...
}:

pkgs.stdenvNoCC.mkDerivation {
  pname = "kwin4_effect_geometry_change";
  version = "v1.5";
  src = pkgs.fetchFromGitHub {
    repo = "kwin4_effect_geometry_change";
    owner = "peterfajdiga";
    rev = "25d92f1fc19c547a9b7b04c3db3cfa150bf3531b";
    hash = "sha256-pa3lHSZ2FtxCh9hyE+3PyV/q/moe15cE3wO0aQEH2vA=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/kwin/effects/kwin4_effect_geometry_change
    cp -r package/* $out/share/kwin/effects/kwin4_effect_geometry_change
  '';

  format = "other";

  nativeBuildInputs = with pkgs; [
    gnumake
  ];
}