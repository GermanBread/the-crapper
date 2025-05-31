#!/bin/sh

sed -i 's|file:///run/current-system/sw/share/applications/|applications:|g' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
sed -i -r 's|file:///home/[^/]+/.local/state/nix/(profiles/)?profile/share/applications/|applications:|g' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
sed -i -r 's|file:///nix/store/[^/]+/share/applications/|applications:|g' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
sed -i -r 's|file:///home/[^/]+/.local/share/flatpak/exports/share/applications/|applications:|g' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
sed -i -r 's|file:///var/lib/flatpak/exports/share/applications/|applications:|g' ~/.config/plasma-org.kde.plasma.desktop-appletsrc
