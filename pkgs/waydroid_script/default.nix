let
  pkgs = import <nixpkgs> {};
in with pkgs.python3.pkgs; buildPythonApplication {
  pname = "waydroid_script";
  version = "0";
  src = pkgs.fetchFromGitHub {
    repo ="waydroid_script";
    owner = "casualsnek";
    rev = "489159c5f90aabb211ce4e960d7de0378120a11e";
    hash = "sha256-lr3MndlJqOgUm89v6rvqtYMjPKriGZVyMvljl2uYzKA=";
  };
  
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    for i in tools bin stuff; do
      cp -a $i $out/bin/$i
    done
    install -m755 main.py $out/bin/main.py
  '';

  format = "other";

  propagatedBuildInputs = [
    tqdm
    requests
    inquirer
  ];
}
