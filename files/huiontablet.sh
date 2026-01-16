#!/usr/bin/env nix-shell
#!nix-shell -i bash -p xmodmap
basedir="$(realpath "${0%/*}")"

export LD_LIBRARY_PATH="$basedir"/libs
export QT_QPA_PLATFORM_PLUGIN_PATH="$basedir"/plugins
export QML2_IMPORT_PATH="$basedir"/qml
export PATH="$PATH":"$basedir"/xdotool
dirname="$basedir" # else crash
appname="huiontablet"

pkill huionCore
pkill huiontablet

$basedir/huionCore        -d &
$basedir/huiontablet "$@" -d
wait
