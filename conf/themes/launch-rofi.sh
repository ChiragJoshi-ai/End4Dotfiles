#!/bin/bash

THEME="$(cat ~/.config/themes/current)"

rofi -show drun -theme ~/.config/themes/$THEME/rofi/theme.rasi
