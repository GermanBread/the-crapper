#!/bin/sh
nix-shell -I nixpkgs='https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz' "$@"