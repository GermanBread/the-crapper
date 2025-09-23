#!/usr/bin/env bash

path=
if [ $# -le 1 ]; then
cat <<-EOF
not enough arguments given

  nixpkpgs subpath
  query/args...

regex supported
EOF
  exit 1
fi
path="$1"
shift
grep -ER "$@" "@nixpkgs@/${path#/}" | sed 's,^@nixpkgs@/,/etc/nixpkgs/,gm'