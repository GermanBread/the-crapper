{ callPackages, callPackage, ... }: {
  kwin4_effect_geometry_change = callPackage ./pkgs/kwin4_effect_geometry_change {};
  writeJavaScript = callPackage ./pkgs/writeJavaScript {};
  huiontablet = callPackage ./pkgs/huiontablet {};
  scripts = callPackages ./scripts {};
}