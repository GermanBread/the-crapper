#!/usr/bin/env bash
set -xe

export PATH="@extras@":"$PATH"
configroot="${XDG_CONFIG_HOME:="$HOME"/.config}"/huiontablet

mkdir -p "$configroot"
cd "$configroot"

mkdir -p res

for tgt in log.conf libs plugins qml xdotool doc LGPL res/{DevImg,Lang.json,StatuImg.js}; do
    rm -rf "$tgt"
    ln -s @src@/lib/huiontablet/"$tgt" "$tgt" &
done
for file in huiontablet.sh huionCore huiontablet; do
    rm -f "$file"
    install -m700 @src@/lib/huiontablet/"$file" "$file" &
done
# copy these default config files
for file in res/{,layout_}{pen,tablet}.cfg res/{,user}.cfg; do
  if [[ ! -e $file ]]; then
    install -m700 @src@/lib/huiontablet/"$file" "$file" &
  fi
done

wait

# scaling factor is "close enough", only works on 100% scaling for ALL screens
ffmpeg -loglevel error -y -i <(spectacle -n -i -f -b -o /dev/stdout) -vf scale="iw*1/4":-1 res/screen.png &

kwriteconfig6 --file kcminputrc \
    --group Libinput --group 9580 --group 61165 --group 'HUION 256C PEN STYLUS' \
    --key MapToWorkspace --type bool true --notify &
kwriteconfig6 --file kwinrc \
    --group Xwayland --key XwaylandEavesdrops All --notify &
kwriteconfig6 --file kwinrc \
    --group Xwayland --key XwaylandEavesdropsMouse --type bool true --notify &
kwriteconfig6 --file kwinrc \
    --group Xwayland --key XwaylandEisNoPrompt --type bool true --notify &

wait

chmod -R 700 "$configroot"

export LD_LIBRARY_PATH="$configroot"/libs
export QT_QPA_PLATFORM_PLUGIN_PATH="$configroot"/plugins
export QML2_IMPORT_PATH="$configroot"/qml
export PATH="$PATH":"$configroot"/xdotool
dirname="$configroot" # else crash
appname="huiontablet"

"$configroot"/huionCore        -d &
"$configroot"/huiontablet "$@" -d

pkill huionCore