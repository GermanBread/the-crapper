#!/usr/bin/env bash

pkgs="$(nix-instantiate --eval --expr '<nixpkgs>')"
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
grep -ER "$@" "$pkgs/${path#/}" | sed "s,^$pkgs/,/etc/nixpkgs/,gm"