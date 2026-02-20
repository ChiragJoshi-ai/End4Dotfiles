#!/usr/bin/env bash

# Kill running instances
pkill waybar
pkill swaync

sleep 0.3

# Start swaync
swaync &

# Read current theme (REQUIRED)
THEME="$(cat ~/.config/themes/current)"

# Start Waybar with selected theme
waybar \
  -c ~/.config/themes/$THEME/waybar/config.jsonc \
  -s ~/.config/themes/$THEME/waybar/style.css &
