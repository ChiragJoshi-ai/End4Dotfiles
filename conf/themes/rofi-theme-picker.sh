#!/usr/bin/env bash

# If rofi is already running, close it
if pgrep -x rofi >/dev/null; then
    pkill rofi
    exit 0
fi

THEME=$(rofi -dmenu -p "Theme" -theme ~/.config/rofi/launchers/type-2/style-1.rasi \
        < ~/.config/themes/themes.txt)

# If user cancelled, do nothing
[ -z "$THEME" ] && exit 0

~/.config/themes/switch-theme.sh "$THEME"
