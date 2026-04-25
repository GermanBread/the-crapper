#!/bin/sh
set -eo pipefail

PKGS="";

while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            echo "$0 [...pkgs] [-- command]"
	    echo -e "-s --add-steam-fhs\tAdd Steam FHS to packages"
            exit 0
        ;;
	-s|--add-steam-fhs)
	    PKGS="$PKGS steam-fhsenv-without-steam.fhsenv zlib libkrb5 libgcc fusePackages.fuse_2 fusePackages.fuse_3 dbus systemd util-linux"
            shift
	;;
        --)
            shift
	    CMD="$*"
            break
        ;;
        *)
            PKGS="$PKGS $1"
            shift
        ;;
    esac
done

case ${SHELL##*/} in
    zsh)
        PKGS="${PKGS} zsh"
        ;;
    fish)
        PKGS="${PKGS} fish"
        ;;
    *)
        ;;
esac

PKGS="$(echo "${PKGS}" | xargs)"

echo "package list: \"${PKGS}\""

export NIXPKGS_ALLOW_UNFREE=1
SHELLENV=$(nix-build --quiet -E "with import <nixpkgs> {}; buildFHSUserEnv { name = \"fhs-shell-env\"; targetPkgs = pkgs: with pkgs; [ ${PKGS} ]; }" --no-out-link)

if [ -z "$CMD" ]; then
    echo "entering FHS env..."
    exec "$SHELLENV"/bin/fhs-shell-env -c "${SHELL##*/}"
else
    exec "$SHELLENV"/bin/fhs-shell-env -c "$CMD"
fi
