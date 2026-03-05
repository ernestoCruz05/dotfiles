#!/bin/bash

# Change this line to whatever CLI you use to control ur audio
case $1 in
up) wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ ;;
down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

volume=$(echo "$status" | awk '{print int($2 * 100)}')
muted=$(echo "$status" | grep -q MUTED && echo "yes" || echo "no")

if [[ "$muted" == "yes" ]]; then
  notify-send -t 1500 -h string:x-dunst-stack-tag:volume "Volume" "Muted"
else
  notify-send -t 1500 -h string:x-dunst-stack-tag:volume -h int:value:"$volume" "Volume" "${volume}%"
fi
