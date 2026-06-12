-- dunst-gif.lua
--
-- Plays a gif/video as a real (color) image animation inside a dunst popup, by
-- cycling extracted PNG frames as the notification icon. For rice. Choppy by
-- nature (one dbus redraw per frame).
--
-- Trigger:  dunst_gif
-- REQUIRES dunstrc `max_icon_size` >= WIDTH below, so dunst renders frames big
-- (and the popup `width` should be >= WIDTH or the frame gets clamped).
--
-- Frames are extracted+scaled once and cached; replays are instant. Everything
-- runs in a spawned shell (off the event loop), so it can never freeze the engine.

local GIF      = os.getenv("HOME") .. "/apple.gif" -- the clip to play
local FPS      = "10"  -- playback / extraction frames per second
local DURATION = "15"  -- seconds of the source to use (keeps it sane)
local WIDTH    = "240" -- frame width in px (keep <= dunst max_icon_size & popup width)
local LOOPS    = "1"   -- how many times to play through
local LABEL    = "▶"   -- caption; dunst DROPS notifications with empty text, so keep non-empty

local SCRIPT = [==[
SRC=$1; FPS=$2; DUR=$3; WIDTH=$4; LOOPS=$5; LABEL=$6
TAG=string:x-dunst-stack-tag:dgif

[ -f "$SRC" ] || { dunstify -t 2500 -h "$TAG" -a Gif "dunst_gif" "Not found: $SRC"; exit 0; }

key=$(printf '%s' "$SRC-$FPS-$DUR-$WIDTH-img" | md5sum | cut -c1-16)
cache="${XDG_CACHE_HOME:-$HOME/.cache}/mplug-dunstgif/$key"

if [ ! -d "$cache" ]; then
  dunstify -t 2000 -h "$TAG" -a Gif "dunst_gif" "rendering frames…"
  tmp="${cache}.tmp.$$"
  mkdir -p "$tmp"
  if ! ffmpeg -loglevel error -i "$SRC" -t "$DUR" -vf "fps=$FPS,scale=$WIDTH:-2" "$tmp/f%04d.png" </dev/null; then
    rm -rf "$tmp"
    dunstify -t 2500 -h "$TAG" -a Gif "dunst_gif" "ffmpeg failed"
    exit 1
  fi
  mkdir -p "$(dirname "$cache")"
  mv "$tmp" "$cache"
fi

set -- "$cache"/f*.png
[ -e "$1" ] || { dunstify -t 2500 -h "$TAG" -a Gif "dunst_gif" "no frames"; exit 0; }

delay=$(awk "BEGIN{ print 1/$FPS }")
loop=0
while [ "$loop" -lt "$LOOPS" ]; do
  for img in "$cache"/f*.png; do
    dunstify -t 1500 -h "$TAG" -a Gif -i "$img" "$LABEL"
    sleep "$delay"
  done
  loop=$((loop + 1))
done
]==]

local function play()
    mplug.spawn("sh", { args = { "-c", SCRIPT, "dunstgif", GIF, FPS, DURATION, WIDTH, LOOPS, LABEL } })
end

mplug.add_listener(function(event, state)
    if event.type == "UserCommand" and event.name == "dunst_gif" then
        play()
    end
end)
