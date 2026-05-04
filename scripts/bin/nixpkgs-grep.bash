#!/usr/bin/env bash

declare pkgs='' path=''

if [ $# -lt 2 ]; then
cat <<-EOF
At least two arguments expected:

 - Subpath in <nixpkgs>
 - Search term (RegExp)
 - Arguments to grep ... (optional)
EOF
    exit 1
fi

pkgs="$(nix-instantiate --eval --expr '<nixpkgs>')"
path="$1"
shift

grep -ER "$@" "$pkgs"'/'"${path#/}" | sed 's,^'"$pkgs"'/,/etc/nixpkgs/,gm'