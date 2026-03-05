#!/bin/bash

DIR="$HOME/Pictures/Screenshots"
FILE="$DIR/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

mkdir -p "$DIR"

GEOM=$(slurp) || exit 1

grim -g "$GEOM" - | tee "$FILE" | wl-copy
