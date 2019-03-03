#!/bin/bash
# Fixes bold fonts in KDE.
# See: https://bugs.kde.org/show_bug.cgi?id=378523
sed -i 's/,Regular//' \
    ~/.config/kdeglobals \
    ~/.config/kateschemarc \
    ~/.config/konsolerc \
    ~/.local/share/konsole/*.profile
