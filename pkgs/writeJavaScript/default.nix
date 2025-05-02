let
  pkgs = import <nixpkgs> {};
in name: text: pkgs.writeShellScript name ''
  ${pkgs.lib.getExe pkgs.nodejs_latest} ${pkgs.writeText "${name}-text" text}
''
