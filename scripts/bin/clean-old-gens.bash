#!/usr/bin/env bash

set -u
shopt -s nullglob

trap 'exit 130' INT

spinner() {
    if [[ ! -t 1 ]]; then
        "$@"
        return
    fi
    log="$(mktemp -t log.XXXXX)"
    ("$@" &>"$log") &
    proc=$!
    while [[ -e /proc/$proc ]]; do
        local i=$(date +%s) chars=("|" "/" "-" "\\")
        (( i %= 4 ))
        echo -ne "\r ${chars[i]} [$@] $(tail -n1 "$log")\033[0K"
        sleep .1s
    done
    wait "$proc"
    if [[ $? -gt 0 ]]; then
        echo -e "\rerrored [$@]\033[0K"
    else
        echo -e "\rcompleted [$@]\033[0K"
    fi
    rm -f "$log"
}

[[ $(id -u) -ne 0 ]] && exec run0 "$0" "$@"

echo -ne "\033[0m\033[?7l"

IFS=$'\n' read -r -d '' -a usersList < <(getent shadow | awk -F':' '$2 != "!" {print$1}' | uniq)
if [[ -n "${usersList[*]}" ]]; then
    echo "removing generations for users ( ${usersList[@]} )..."
    for i in "${usersList[@]}"; do
        spinner su "$i" -lc 'nix-env --delete-generations +3'
    done
fi

echo "removing generations for global profiles..."
for p in /nix/var/nix/profiles/per-user/*/{profile,home-manager}; do
    spinner nix-env --profile "$p" --delete-generations +3
done
spinner nix-env --profile /nix/var/nix/profiles/system --delete-generations +3

echo "nuking boot entries..."
spinner /nix/var/nix/profiles/system/bin/switch-to-configuration boot

echo "running garbage collection..."
spinner nix-collect-garbage

echo "done"

echo -ne "\033[0m\033[?7h"