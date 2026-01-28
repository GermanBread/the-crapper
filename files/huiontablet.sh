#!/usr/bin/env nix-shell
#!nix-shell -i bash -p xmodmap kdePackages.kconfig

# SETUP INSTRUCTIONS
# 1. create a directory called "huiontablet" (it must be called that, but it may be placed anywhere, preferrably in ~)
# 2. cd into said directory
# 3. copy this script & make it executable
# 4. `nix-build /path/to/repo/dev.nix -A huiontablet -o result` (to avoid gc, moving the symlink will BREAK the gcroot!)
# 5. import the kwin rules from the repo
# done :D

basedir="$(realpath "${0%/*}")"
cd "$basedir"
echo "$basedir"

for tgt in {libs,plugins,qml,xdotool,doc,LGPL,log.conf}; do
    rm -rf "$tgt"
    ln -s result/lib/huiontablet/"$tgt" "$tgt" &
done
for tgt in res/{DevImg,Lang.json,StatuImg.js}; do
    rm -rf "$tgt"
    ln -s ../result/lib/huiontablet/"$tgt" "$tgt" &
done
for file in huionCore huiontablet; do
    rm -f "$file"
    cp result/lib/huiontablet/"$file" "$file" &
done

wait

# scaling factor is "close enough", only works on 100% scaling for ALL screens
ffmpeg -loglevel error -y -i <(spectacle -n -i -f -b -o /dev/stdout) -vf scale="iw*1/4":-1 res/screen.png &

kwriteconfig6 --file kcminputrc \
    --group Libinput --group 9580 --group 61165 --group 'HUION 256C PEN STYLUS' \
    --key MapToWorkspace --type bool true --notify &

wait

chmod -R 700 "$basedir"

export LD_LIBRARY_PATH="$basedir"/libs
export QT_QPA_PLATFORM_PLUGIN_PATH="$basedir"/plugins
export QML2_IMPORT_PATH="$basedir"/qml
export PATH="$PATH":"$basedir"/xdotool
dirname="$basedir" # else crash
appname="huiontablet"

pkill huionCore
pkill huiontablet

"$basedir"/huionCore        -d &
"$basedir"/huiontablet "$@" -d

wait

pkill huionCore
pkill huiontablet
rm -f .*.pid
