#!/bin/bash
# zec Stop Hook — delegates to .zec/bridge/persistent-mode.cjs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
BRIDGE="$PROJECT_DIR/.zec/bridge"

# Node.js bridge가 있으면 위임, 없으면 기본 bash 로직
if [ -f "$BRIDGE/persistent-mode.cjs" ] && command -v node >/dev/null 2>&1; then
  exec node "$BRIDGE/persistent-mode.cjs"
fi

# Fallback: 기본 bash 지속성 로직
source "$SCRIPT_DIR/lib/state.sh"
source "$SCRIPT_DIR/lib/observation.sh" 2>/dev/null || true

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
cat > "$temp_file"

for mode in ralph ultrawork autopilot; do
  if [ -f "$STATE_DIR/$mode.json" ]; then
    active=$(jq -r '.active // false' "$STATE_DIR/$mode.json" 2>/dev/null)
    if [ "$active" = "true" ]; then
      iter=$(jq -r '.iteration // 1' "$STATE_DIR/$mode.json" 2>/dev/null)
      max=$(jq -r '.max_iterations // 50' "$STATE_DIR/$mode.json" 2>/dev/null)
      if [ "$iter" -ge "$max" ] 2>/dev/null; then
        jq '.active = false' "$STATE_DIR/$mode.json" > "$STATE_DIR/$mode.json.tmp"
        mv "$STATE_DIR/$mode.json.tmp" "$STATE_DIR/$mode.json"
        echo "{\"systemMessage\": \"[$mode] Max iterations ($max) reached. Mode deactivated.\"}"
        exit 0
      fi
      new_iter=$((iter + 1))
      jq --argjson i "$new_iter" '.iteration = $i' "$STATE_DIR/$mode.json" > "$STATE_DIR/$mode.json.tmp"
      mv "$STATE_DIR/$mode.json.tmp" "$STATE_DIR/$mode.json"
      MODE_UPPER=$(echo "$mode" | tr '[:lower:]' '[:upper:]')
      echo "{\"systemMessage\": \"[$MODE_UPPER #$iter/$max] Continue working.\"}"
      exit 2
    fi
  fi
done
exit 0
