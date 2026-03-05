#!/bin/bash

dunstctl close-all

create_button() {
  local tag=$1
  local icon=$2
  local text=$3
  local command=$4

  local result=$(dunstify -a "PowerMenu" -t 5000 -h string:x-dunst-stack-tag:"$tag" -A "run,Execute" " " "<span font='10'>$icon</span>   <span font='10'>$text</span>")

  if [ "$result" = "run" ]; then
    dunstctl close-all
    eval "$command"
  fi
}

# Change hyprlock to whatever you use
create_button "menu_shutdown" "" "Shutdown" "systemctl poweroff" &
sleep 0.02
create_button "menu_reboot" "󰜉" "Reboot" "systemctl reboot" &
sleep 0.02
create_button "menu_lock" "" "Lock Screen" "hyprlock" &
sleep 0.02
create_button "menu_logout" "󰗽" "Log Out" "loginctl terminate-session $XDG_SESSION_ID" &

wait
