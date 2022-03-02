let
  pkgs = import <nixpkgs> {};
in

{
  processing4 = pkgs.callPackage ./fhsenv.nix {};
}