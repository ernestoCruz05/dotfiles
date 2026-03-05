#!/bin/bash

last_workspace=""

mmsg -w | while read -r event; do

  if [[ "$event" =~ [01]{9} ]]; then

    sel_mask=$(echo "$event" | grep -o -E "[01]{9}" | sed -n '2p')

    workspace=$(awk -v a="$sel_mask" 'BEGIN{idx=index(a,"1"); if(idx>0) print 10-idx}')

    if [[ -n "$workspace" ]] && [[ "$workspace" != "$last_workspace" ]]; then

      notify-send -t 1000 -h string:x-dunst-stack-tag:workspace "Workspace" "[ $workspace ]"

      last_workspace="$workspace"

    fi
  fi
done
