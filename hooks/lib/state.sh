#!/bin/bash
# State management library for zec
STATE_DIR="${CLAUDE_PROJECT_DIR:-.}/.zec/state"

read_state() { local mode="$1"; cat "$STATE_DIR/$mode.json" 2>/dev/null || echo '{}'; }
write_state() {
  local mode="$1" json="$2"
  mkdir -p "$STATE_DIR"
  local tmp="$STATE_DIR/$mode.json.tmp"
  echo "$json" > "$tmp" && mv "$tmp" "$STATE_DIR/$mode.json"
}
clear_state() { local mode="$1"; rm -f "$STATE_DIR/$mode.json"; }
is_active() { local mode="$1"; jq -r '.active // false' "$STATE_DIR/$mode.json" 2>/dev/null; }
list_active() {
  for f in "$STATE_DIR"/*.json; do
    [ -f "$f" ] || continue
    local mode=$(basename "$f" .json)
    local active=$(jq -r '.active // false' "$f" 2>/dev/null)
    [ "$active" = "true" ] && echo "$mode"
  done
}
