{ callPackages, callPackage, ... }: {
  kwin4_effect_geometry_change = callPackage ./foreign/kwin4_effect_geometry_change {};
  writeJavaScript = callPackage ./own/writeJavaScript {};
  huiontablet = callPackage ./foreign/huiontablet {};
  scripts = callPackages ./own/scripts {};
}