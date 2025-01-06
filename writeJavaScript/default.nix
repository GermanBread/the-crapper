{ lib, writeShellScript, writeText, nodejs_latest }:

name: text: writeShellScript name ''
  ${lib.getExe nodejs_latest} ${writeText "${name}-text" text}
''