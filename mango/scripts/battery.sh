#!/bin/bash

capacity=$(cat /sys/class/power_supply/BAT*/capacity | head -n 1)
status=$(cat /sys/class/power_supply/BAT*/status | head -n 1)

notify-send -t 2000 -h string:x-dunst-stack-tag:battery "Battery" "${capacity}% ($status)"
