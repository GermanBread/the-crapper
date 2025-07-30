#!/usr/bin/env bash

set -u

trap 'exit 130' INT

spinner() {
    log="$(mktemp -t log.XXXXX)"
    ("$@" &>"$log") &
    proc=$!
    while [ -e /proc/$proc ]; do
        local i=$(date +%s) chars=("|" "/" "-" "\\")
        (( i %= 4 ))
        echo -ne "\r ${chars[i]} [$@] $(tail -n1 "$log")\033[0K"
        sleep .1s
    done
    wait "$proc"
    if [ $? -gt 0 ]; then
        echo -e "\rerrored [$@]\033[0K"
    else
        echo -e "\rcompleted [$@]\033[0K"
    fi
    rm -f "$log"
}

# shellcheck disable=SC2086
[ "$(id -u)" -ne 0 ] && exec sudo "$0" "$@"

echo -ne "\033[0m\033[?7l"

IFS=$'\n' read -r -d '' -a usersList < <(getent shadow | awk -F':' '$2 != "!" {print$1}' | uniq)
if [ -n "${usersList[*]}" ]; then
    echo "running garbage collection for users ( ${usersList[@]} )..."
    for i in "${usersList[@]}"; do
        spinner sudo -u "$i" nix-collect-garbage -d
    done
fi

echo "running garbage collection..."
spinner nix-collect-garbage -d

echo "nuking boot entries..."
spinner /nix/var/nix/profiles/system/bin/switch-to-configuration boot

echo "running garbage collection again..."
spinner nix-collect-garbage

echo "done"

echo -ne "\033[0m\033[?7h"