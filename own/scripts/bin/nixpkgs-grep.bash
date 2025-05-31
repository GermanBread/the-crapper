#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "no arguments given (regex supported)"
  exit 1
fi
cd "@nixpkgs@" || exit 1; grep -ER "$@" .