-- app-volume.lua
--
-- Per-application volume for the FOCUSED window. With sloppyfocus=1 that's the
-- window under your cursor, so: hover a window, scroll, that app's volume moves.
--
-- Triggers (bind these in mango):
--   app_vol_up | app_vol_down | app_vol_mute
--
-- Bind app_vol_up/down to SUPER+ALT scroll, and app_vol_mute to a key.
--
-- Everything runs via mplug.spawn (off the event loop), so it can never freeze
-- the engine. It matches the focused window's app_id to a PipeWire sink-input by
-- binary/name (fuzzy, two-way) and adjusts every matching stream. dunst shows a
-- live bar. If nothing matches, dunst says so (use the mute/cycle later).

local STEP = "5" -- percent per scroll tick

local SCRIPT = [==[
APP=$1
ACTION=$2
STEP=${3:-5}

[ -z "$APP" ] && { dunstify -t 1500 -h string:x-dunst-stack-tag:appvol -a AppVol "App volume" "No focused window"; exit 0; }

full=$(printf '%s' "$APP" | tr '[:upper:]' '[:lower:]')
short=$(printf '%s' "$full" | sed 's/.*\.//')
[ -z "$short" ] && short="$full"

json=$(pactl -f json list sink-inputs 2>/dev/null)

idxs=$(printf '%s' "$json" | jq -r --arg s "$short" --arg f "$full" '
  .[]
  | ((.properties["application.process.binary"] // "") | ascii_downcase) as $bin
  | ((.properties["application.name"] // "") | ascii_downcase) as $nm
  | select(
        ($bin != "" and ($bin | contains($s)))
     or ($nm  != "" and ($nm  | contains($s)))
     or ($bin != "" and ($f | contains($bin)))
     or ($nm  != "" and ($f | contains($nm)))
    )
  | .index')

if [ -z "$idxs" ]; then
  dunstify -t 1500 -h string:x-dunst-stack-tag:appvol -a AppVol "App volume" "No audio stream for $APP"
  exit 0
fi

for idx in $idxs; do
  case "$ACTION" in
    mute) pactl set-sink-input-mute "$idx" toggle ;;
    up|down)
      cur=$(printf '%s' "$json" | jq -r --argjson i "$idx" '.[] | select(.index==$i) | (.volume | to_entries[0].value.value_percent)' | tr -d '%')
      [ -z "$cur" ] && cur=0
      if [ "$ACTION" = up ]; then
        new=$((cur + STEP)); [ "$new" -gt 100 ] && new=100
      else
        new=$((cur - STEP)); [ "$new" -lt 0 ] && new=0
      fi
      pactl set-sink-input-volume "$idx" "${new}%" ;;
  esac
done

first=$(printf '%s' "$idxs" | head -n1)
after=$(pactl -f json list sink-inputs 2>/dev/null)
vol=$(printf '%s' "$after" | jq -r --argjson i "$first" '.[] | select(.index==$i) | (.volume | to_entries[0].value.value_percent)' | tr -d '%')
mute=$(printf '%s' "$after" | jq -r --argjson i "$first" '.[] | select(.index==$i) | .mute')
name=$(printf '%s' "$after" | jq -r --argjson i "$first" '.[] | select(.index==$i) | (.properties["application.name"] // .properties["application.process.binary"] // "App")')
[ -z "$vol" ] && vol=0

if [ "$mute" = "true" ]; then
  dunstify -t 1500 -h string:x-dunst-stack-tag:appvol -a AppVol "$name" "Muted"
else
  dunstify -t 1500 -h string:x-dunst-stack-tag:appvol -h "int:value:$vol" -a AppVol "$name" "${vol}%"
fi
]==]

local function control(app_id, action)
    mplug.spawn("sh", { args = { "-c", SCRIPT, "appvol", app_id or "", action, STEP } })
end

mplug.add_listener(function(event, state)
    if event.type ~= "UserCommand" then return end
    local app = (state.focused_window and state.focused_window.app_id) or ""
    if event.name == "app_vol_up" then
        control(app, "up")
    elseif event.name == "app_vol_down" then
        control(app, "down")
    elseif event.name == "app_vol_mute" then
        control(app, "mute")
    end
end)
