{ callPackage }: {
  writeJavaScript = callPackage ./writeJavaScript {};
  scripts = callPackage ./scripts {};
}