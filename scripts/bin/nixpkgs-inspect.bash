#!/usr/bin/env bash

declare pkgs='' path=''

if [ $# -lt 1 ]; then
cat <<-EOF
At least one argument expected:

 - Subpath in <nixpkgs>
 - Arguments to $EDITOR ... (optional)
EOF
    exit 1
fi

pkgs="$(nix-instantiate --eval --expr '<nixpkgs>')"
path="$1"
shift

exec "$EDITOR" "$@" "$pkgs/${path#/}"