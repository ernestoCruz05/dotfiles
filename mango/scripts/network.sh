#!/bin/bash

# Warnings are not working so well, but they "do the job more or less"
if ping -c 1 -W 1 1.1.1.1 &>/dev/null; then
  ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d':' -f2)

  if [ -n "$ssid" ]; then
    notify-send -t 2000 -h string:x-dunst-stack-tag:network "Network" "Connected: $ssid"
  else
    notify-send -t 2000 -h string:x-dunst-stack-tag:network "Network" "Connected (Ethernet/Unknown)"
  fi
else
  notify-send -t 2000 -h string:x-dunst-stack-tag:network "Network" "Disconnected"
fi
