#!/bin/bash
# Toggles between light and dark console background.
set -euo pipefail

konsole_profile_dir=~/.local/share/konsole
konsole_color_scheme_light=BlackOnLightYellow
konsole_color_scheme_dark=DarkPastels

vimrc=~/.vimrc
nvimrc=~/.config/nvim/init.vim

is_light() {
    grep -q "^set bg=light" "$vimrc"
}

if is_light; then
    bgcolor=dark
    konsole_color_scheme=$konsole_color_scheme_dark
else
    bgcolor=light
    konsole_color_scheme=$konsole_color_scheme_light
fi

echo "Switching to $bgcolor background"

sed -i 's/^\(set bg=\).*/\1'"$bgcolor/" "$vimrc" "$nvimrc"

sed -i 's/^\(ColorScheme=\).*/\1'"$konsole_color_scheme/" "$konsole_profile_dir"/*.profile
