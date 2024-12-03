{ pkgs ? import <nixpkgs> {} }:

rec {
  wallpaper-engine-kde-plugin = pkgs.libsForQt5.callPackage ./we-kde {};
  waydroid_script = pkgs.callPackage ./waydroid_script {};
  processing4 = pkgs.callPackage ./processing4 {};
  fetchcord   = pkgs.callPackage ./fetchcord {};
  "42" = pkgs.callPackage ./42 {};
  
  # aliases
  we-kde = wallpaper-engine-kde-plugin;
}