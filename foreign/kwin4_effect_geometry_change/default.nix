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
    rev = "a7a490c43c877e5e58d45d6c0561a79140c8eca5";
    hash = "sha256-p4FpqagR8Dxi+r9A8W5rGM5ybaBXP0gRKAuzigZ1lyA=";
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