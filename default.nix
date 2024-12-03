{ pkgs ? import <nixpkgs> {} }:

rec {
  wallpaper-engine-kde-plugin = pkgs.libsForQt5.callPackage ./we-kde {};
  processing4 = pkgs.callPackage ./processing4 {};
  fetchcord   = pkgs.callPackage ./fetchcord {};
  
  # aliases
  we-kde = wallpaper-engine-kde-plugin;
}