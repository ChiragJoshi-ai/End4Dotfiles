#!/usr/bin/env bash

random_transition() {
    shuf -n1 <<EOF
fade
wipe
grow
outer
any
EOF
}

get_active_resolution() {
    hyprctl monitors \
      | awk '/focused: yes/ {getline; print $1}' \
      | grep -oE '[0-9]+x[0-9]+'
}

apply_wallpaper_safely() {
    local IMG="$1"
    local TRANSITION="$2"

    swww img "$IMG" \
      --resize fit \
      --fill-color 000000 \
      --transition-type "$TRANSITION"
}
