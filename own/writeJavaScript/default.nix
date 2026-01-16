{ writeShellScript
, nodejs_latest
, writeText
, lib
}:

name: text:
writeShellScript name ''
  ${lib.getExe nodejs_latest} ${writeText "${name}-text" text}
''