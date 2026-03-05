#!/bin/bash

icons=()

# There is probably a way to do this more cleanly but it works and its not too much of a hassle
# Just add the Nerd Font icon and the if statement and it should start being detected
# If the app doesnt have a Nerd Font Icon, you could use magick to render the image, but idk how well that would work

if pgrep -x "discord" >/dev/null || pgrep -x "vesktop" >/dev/null; then
  icons+=("")
fi

if pgrep -x "steam" >/dev/null; then
  icons+=("")
fi

if pgrep -x "spotify" >/dev/null; then
  icons+=("")
fi

if pgrep -x "easyeffects" >/dev/null; then
  icons+=("")
fi

if [ ${#icons[@]} -gt 0 ]; then

  output=""
  for i in "${!icons[@]}"; do
    output+="${icons[$i]}"
    if [ $i -lt $((${#icons[@]} - 1)) ]; then
      output+="   "
    fi
  done

  notify-send -a "Radar" -t 2500 -h string:x-dunst-stack-tag:radar "Radar" "<span foreground='#FFFFFF' font='12'>$output</span>"
else
  notify-send -a "Radar" -t 2000 -h string:x-dunst-stack-tag:radar "<span foreground='#FFFFFF'>System Clear</span>"
fi
