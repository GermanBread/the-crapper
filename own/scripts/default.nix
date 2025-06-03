{ pkgs, lib, ... }:
let
  inherit (lib)
    makeBinPath
    ;
  inherit (pkgs)
    runCommandNoCC
    gnused
    util-linux
    makeWrapper
    gnutar
    gnugrep
    findutils
    usbutils
    ;

  basicScript =
    name:
    runCommandNoCC name
      {
      }
      ''
        mkdir -p $out/bin
        install -m755 ${./bin/${name}.bash} $out/bin/${name}
        patchShebangs $out/bin/${name}
      '';
  pathScript =
    name: paths:
    runCommandNoCC name
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        install -m755 ${./bin/${name}.bash} $out/bin/${name}
        patchShebangs $out/bin/${name}
        wrapProgram $out/bin/${name} --prefix PATH : "${makeBinPath paths}"
      '';
in
{
  clean-old-gens = basicScript "clean-old-gens";
  gen-machine-id = pathScript "gen-machine-id" [ util-linux ];
  nixpkgs-grep =
    runCommandNoCC "nixpkgs-grep"
      {
        nativeBuildInputs = [ makeWrapper ];
        nixpkgs = pkgs.path;
      }
      ''
        mkdir -p $out/bin
        substitute ${./bin/nixpkgs-grep.bash} $out/bin/nixpkgs-grep --subst-var nixpkgs
        patchShebangs $out/bin/nixpkgs-grep
        chmod 755 $out/bin/nixpkgs-grep
        wrapProgram $out/bin/nixpkgs-grep --prefix PATH : "${makeBinPath [ gnugrep ]}"
        ln -s nixpkgs-grep $out/bin/ng
      '';
  nr = basicScript "nr";
  publicip = basicScript "publicip";
  fhs-shell = basicScript "fhs-shell";
  sandbox-shell = basicScript "sandbox-shell";
  iommu-groups = pathScript "iommu-groups" [ findutils ];
  usb-controllers = pathScript "usb-controllers" [ usbutils ];
  fix-plasma-icons = pathScript "fix-plasma-icons" [ gnused ];
}