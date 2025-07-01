#!/usr/bin/env bash

set -u

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
    echo -e "\rcompleted [$@]\033[0K"
    cat "$log" | $PAGER
    rm -f "$log"
}

spinner "$@"