{ pkgs ? import <nixpkgs> {} }: let 
  inherit (pkgs) callPackage;
in

rec {
  wallpaper-engine-kde-plugin = callPackage ./we-kde {};
  waydroid_script = callPackage ./waydroid_script {};
  processing4 = callPackage ./processing4 {};
  fetchcord   = callPackage ./fetchcord {};
  "42" = callPackage ./42 {};
  
  # aliases
  we-kde = wallpaper-engine-kde-plugin;
}