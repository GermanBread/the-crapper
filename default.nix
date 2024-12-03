let
  pkgs = import <nixpkgs> {};
in

{
  processing4 = pkgs.callPackage ./processing4/fhsenv.nix {};
}