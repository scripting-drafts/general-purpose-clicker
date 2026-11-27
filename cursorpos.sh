#!/usr/bin/env bash
# Live cursor position on GNOME Wayland.
# Reads the CursorPos shell extension over D-Bus (global.get_pointer()).

BUS=org.local.CursorPos
OBJ=/org/local/CursorPos
METHOD=org.local.CursorPos.Get

if ! pos=$(gdbus call --session --dest "$BUS" --object-path "$OBJ" --method "$METHOD" 2>/dev/null); then
    printf 'CursorPos extension is not running.\n' >&2
    printf 'Enable it, then log out and back in once:\n' >&2
    printf '  gnome-extensions enable cursorpos@local\n' >&2
    exit 1
fi

# Initial reading:  (x, y)
if [[ $pos =~ \((-?[0-9]+),\ (-?[0-9]+)\) ]]; then
    printf '\r\033[KX: %s | Y: %s' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
fi

# Stream updates (one persistent gdbus process, no per-frame forks).
gdbus monitor --session --dest "$BUS" --object-path "$OBJ" 2>/dev/null |
while IFS= read -r line; do
    case $line in
      *Changed*)
        if [[ $line =~ \((-?[0-9]+),\ (-?[0-9]+)\) ]]; then
            printf '\r\033[KX: %s | Y: %s' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
        fi
        ;;
    esac
done
