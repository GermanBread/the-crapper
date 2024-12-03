{ pkgs ? import <nixpkgs> {} }: let 
  inherit (pkgs) callPackage;
in

{
  waydroid_script = callPackage ./waydroid_script {};
  fetchcord  = callPackage ./fetchcord {};
  queercat = callPackage ./queercat {};
  "42" = callPackage ./42 {};
}
