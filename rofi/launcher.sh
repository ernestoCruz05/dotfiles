#!/bin/bash

WALLPAPER_DIR="$HOME/.config/rofi/images"

TARGET_IMAGE="$HOME/.config/rofi/sidebar.jpg"

RANDOM_IMG=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

if [ -n "$RANDOM_IMG" ]; then
  ln -sf "$RANDOM_IMG" "$TARGET_IMAGE"
fi

rofi -show drun -theme ~/.config/rofi/sunset.rasi
