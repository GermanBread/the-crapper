let
  pkgs = import <nixpkgs> {};
in with pkgs.python3.pkgs; buildPythonApplication {
  pname = "fetchcord";
  version = "2.7.7";
  src = builtins.fetchTarball {
    url = "https://github.com/fetchcord/FetchCord/archive/refs/tags/v2.7.7.tar.gz";
    sha256 = "sha256:0gn2wng1sbl1a6xwr3x4hvh72054wmznh29xr36ir7vbgsrkgrrn";
  };
  doCheck = false;
  propagatedBuildInputs = [
    psutil pypresence importlib-resources
  ];
}
