#!/usr/bin/env bash
# Requires: xdotool (X11) or wtype/ydotool (Wayland)

while true; do
    pos=$(xdotool getmouselocation --shell)
    X=$(awk -F= '/^X=/{print $2}' <<< "$pos")
    Y=$(awk -F= '/^Y=/{print $2}' <<< "$pos")
    printf '\rX: %s | Y: %s' "$X" "$Y"
    sleep 0.05
done
Faster variant (single call, no subshell parsing):
#!/usr/bin/env bash
while true; do
    read -r line < <(xdotool getmouselocation)
    printf '\r%s' "$line"
    sleep 0.05
done
