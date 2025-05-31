set -uo pipefail

HOSTPATH=$PATH
APPPATH=$(nix eval --raw --impure --expr 'with import <nixpkgs> {}; lib.makeBinPath [ bubblewrap coreutils mktemp xdg-utils  ]')
PATH=$APPPATH:$HOSTPATH

TMPDIR=$(mktemp -d)

# setup
echo "Creating env at ${TMPDIR}"
mkdir -p ${TMPDIR}/{upper,work,mount}
fuse-overlayfs -o lowerdir=$HOME -o workdir=${TMPDIR}/work -o upperdir=${TMPDIR}/upper ${TMPDIR}/mount
if [ -d /media ]; then
    mkdir -p ${TMPDIR}/media/{upper,work,mount}
    fuse-overlayfs -o lowerdir=/media -o workdir=${TMPDIR}/media/work -o upperdir=${TMPDIR}/media/upper ${TMPDIR}/media/mount
fi

echo "Entering sandbox"
if [ -d /media ]; then
    bwrap --dev-bind / / --dev-bind ${TMPDIR}/media/mount /media --bind ${TMPDIR}/mount $HOME --tmpfs /tmp --setenv PATH "$HOSTPATH" $SHELL
else
    bwrap --dev-bind / / --bind ${TMPDIR}/mount $HOME --tmpfs /tmp --setenv PATH "$HOSTPATH" $SHELL
fi

# cleanup
fusermount -u ${TMPDIR}/mount
if [ -d ${TMPDIR}/media ]; then
    fusermount -u ${TMPDIR}/media/mount
fi
rm -rf ${TMPDIR}{,/media}/{work,mount}

# ask user
cat << EOF
What to do with sandbox environment?

[K]eep
[O]pen
[D]elete (default)
EOF
read -p 'Choice (10 seconds timeout): ' -t10 -N1 choice
case ${choice} in
	[Kk]*)
		echo "Sandbox env located at ${TMPDIR}"
		exit 0
	;;
	[Oo]*)
		xdg-open ${TMPDIR}
	;;
	*)
		rm -rf ${TMPDIR}
	;;
esac
