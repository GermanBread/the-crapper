{ callPackages, callPackage, ... }: {
  writeJavaScript = callPackage ./pkgs/writeJavaScript {};
  huiontablet = callPackage ./pkgs/huiontablet {};
  scripts = callPackages ./scripts {};
}