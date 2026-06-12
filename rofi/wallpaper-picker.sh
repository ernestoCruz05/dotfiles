#!/bin/bash
# Rofi-based wallpaper picker with pywal integration

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WAL_SET="$HOME/.local/bin/wal-set"

# Get list of wallpapers
wallpapers=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) 2>/dev/null | sort)

if [[ -z "$wallpapers" ]]; then
    notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Create menu entries with just filenames
menu=""
while IFS= read -r wp; do
    name=$(basename "$wp")
    menu+="$name\n"
done <<< "$wallpapers"

# Show rofi menu
selected=$(echo -e "$menu" | rofi -dmenu -p "🎨 Wallpaper" -i -theme-str 'window {width: 400px;}')

if [[ -n "$selected" ]]; then
    # Find the full path
    wallpaper=$(echo "$wallpapers" | grep -F "/$selected" | head -1)
    
    if [[ -f "$wallpaper" ]]; then
        notify-send "Wallpaper Picker" "Applying: $selected" -t 2000
        "$WAL_SET" "$wallpaper"
    fi
fi
