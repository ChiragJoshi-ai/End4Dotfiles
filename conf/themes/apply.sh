#!/bin/bash
source "$HOME/.config/themes/wallpaper-utils.sh"

THEME="$(cat ~/.config/themes/current)"
THEME_DIR="$HOME/.config/themes/$THEME"

echo "Applying theme: $THEME"

### ---------------- WALLPAPER ----------------
WALL_DIR="$THEME_DIR/wallpapers"
LAST_WALL="$THEME_DIR/.current-wallpaper"
TRANSITION=$(random_transition)

if [ -f "$LAST_WALL" ] && [ -f "$WALL_DIR/$(cat "$LAST_WALL")" ]; then
    apply_wallpaper_safely "$WALL_DIR/$(cat "$LAST_WALL")" "$TRANSITION"
elif ls "$WALL_DIR"/default.* >/dev/null 2>&1; then
    apply_wallpaper_safely "$(ls "$WALL_DIR"/default.* | head -n1)" "$TRANSITION"
fi

### ---------------- WAYBAR ----------------
pkill waybar
waybar \
  -c "$THEME_DIR/waybar/config.jsonc" \
  -s "$THEME_DIR/waybar/style.css" &

### ---------------- EWW ----------------
pkill eww 2>/dev/null
eww daemon &
sleep 0.2
eww reload

### ---------------- SWAYNC ----------------
pkill swaync
swaync -c "$THEME_DIR/swaync/config.json" &

### ---------------- KITTY -----------------
ln -sf "$THEME_DIR/kitty/colors.conf" \
       "$HOME/.config/kitty/current-colors.conf"

ln -sf "$THEME_DIR/kitty/opacity.conf" \
       "$HOME/.config/kitty/current-opacity.conf"

kitty @ set-colors -a "$HOME/.config/kitty/current-colors.conf" 2>/dev/null
kitty @ set-background-opacity "$(grep -o '[0-9.]*' "$HOME/.config/kitty/current-opacity.conf")" 2>/dev/null

### ---------------- NOTIFICATION ----------------
sleep 0.3
swaync-client -n "🎨 Theme Applied" "$THEME"

echo "Theme applied successfully."
