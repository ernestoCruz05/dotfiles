#!/bin/bash

if [ -n "$1" ]; then
  playerctl "$1"
  sleep 0.1
fi

status=$(playerctl status 2>/dev/null)

if [ -z "$status" ]; then
  notify-send -t 1500 -h string:x-dunst-stack-tag:player "Media" "No player active"
  exit 0
fi

title=$(playerctl metadata title 2>/dev/null || echo "Unknown Title")
artist=$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")

if [ "$status" = "Playing" ]; then
  notify-send -t 2000 -h string:x-dunst-stack-tag:player "▶  Now Playing" "$title\n$artist"
else
  notify-send -t 2000 -h string:x-dunst-stack-tag:player "⏸  Paused" "$title\n$artist"
fi
