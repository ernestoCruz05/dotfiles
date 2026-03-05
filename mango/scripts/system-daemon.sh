#!/bin/bash

last_net_state=""
notified_low=false

while true; do
  capacity=$(cat /sys/class/power_supply/BAT*/capacity | head -n 1)
  status=$(cat /sys/class/power_supply/BAT*/status | head -n 1)

  if [[ "$status" == "Discharging" ]] && [[ "$capacity" -le 15 ]] && [[ "$notified_low" == false ]]; then
    notify-send -u critical -t 0 -h string:x-dunst-stack-tag:battery "Battery Low" "${capacity}% remaining!"
    notified_low=true
  elif [[ "$status" == "Charging" ]]; then
    notified_low=false
  fi

  if ping -c 1 -W 1 1.1.1.1 &>/dev/null; then
    net_state="up"
  else
    net_state="down"
  fi

  if [[ "$net_state" != "$last_net_state" ]] && [[ -n "$last_net_state" ]]; then
    if [[ "$net_state" == "up" ]]; then
      notify-send -t 3000 -h string:x-dunst-stack-tag:network "Network" "Connection Restored"
    else
      notify-send -u critical -t 3000 -h string:x-dunst-stack-tag:network "Network" "Connection Lost"
    fi
  fi
  last_net_state="$net_state"

  sleep 10
done
