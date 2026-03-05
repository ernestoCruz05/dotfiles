#!/bin/bash

case $1 in
up) brightnessctl set +5% ;;
down) brightnessctl set 5%- ;;
esac

current=$(brightnessctl -m | awk -F, '{print int($4)}')

notify-send -t 1500 -h string:x-dunst-stack-tag:brightness -h int:value:"$current" "Brightness" "${current}%"
