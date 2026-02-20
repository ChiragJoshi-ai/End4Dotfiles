#!/usr/bin/env bash

THEME="$1"
THEME_DIR="$HOME/.config/themes/$THEME"

# stop if theme folder does not exist
[ ! -d "$THEME_DIR" ] && exit 1

# save current theme (single source of truth)
echo "$THEME" > "$HOME/.config/themes/current"

# apply everything
"$HOME/.config/themes/apply.sh"
