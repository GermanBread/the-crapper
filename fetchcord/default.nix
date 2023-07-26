{ pkgs
, python3
, python3Packages }:

with python3.pkgs; buildPythonApplication rec {
  pname = "fetchcord";
  version = "2.7.7";
  src = fetchPypi {
    pname = "FetchCord";
    inherit version;
    sha256 = "sha256-ORjC+pDY4HrWNPY4B+o5YMoGm3O1x1C8WqHOygXRknw=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    psutil pypresence importlib-resources
  ];
}