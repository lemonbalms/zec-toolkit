#!/bin/bash
# zec UserPromptSubmit Hook — delegates to .zec/bridge/keyword-detector.mjs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
BRIDGE="$PROJECT_DIR/.zec/bridge"

# Node.js bridge가 있으면 위임
if [ -f "$BRIDGE/keyword-detector.mjs" ] && command -v node >/dev/null 2>&1; then
  exec node "$BRIDGE/keyword-detector.mjs"
fi

# Fallback: 기본 bash 키워드 감지
source "$SCRIPT_DIR/lib/state.sh"
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
cat > "$temp_file"

prompt=$(jq -r '.prompt // ""' < "$temp_file")
first_word=$(echo "$prompt" | awk '{print tolower($1)}')

case "$first_word" in
  /cancel|cancel)
    for mode in ralph ultrawork autopilot; do
      [ -f "$STATE_DIR/$mode.json" ] && jq '.active = false' "$STATE_DIR/$mode.json" > "$STATE_DIR/$mode.json.tmp" && mv "$STATE_DIR/$mode.json.tmp" "$STATE_DIR/$mode.json"
    done
    echo '{"additionalContext": "All modes cancelled."}'
    ;;
  ralph|ulw|ultrawork|autopilot|design)
    mode="$first_word"
    [ "$mode" = "ulw" ] && mode="ultrawork"
    task=$(echo "$prompt" | sed "s/^[^ ]* //")
    mkdir -p "$STATE_DIR"
    echo "{\"active\":true,\"mode\":\"$mode\",\"iteration\":1,\"max_iterations\":50,\"task\":\"$task\",\"started_at\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" > "$STATE_DIR/$mode.json"
    echo "{\"additionalContext\": \"[$mode] Mode activated. The boulder never stops.\"}"
    ;;
  *)
    # 활성 모드 컨텍스트 주입
    for mode in ralph ultrawork autopilot; do
      if [ -f "$STATE_DIR/$mode.json" ]; then
        active=$(jq -r '.active // false' "$STATE_DIR/$mode.json" 2>/dev/null)
        if [ "$active" = "true" ]; then
          MODE_UPPER=$(echo "$mode" | tr '[:lower:]' '[:upper:]')
          echo "{\"additionalContext\": \"[ACTIVE MODE: $MODE_UPPER] The boulder never stops.\"}"
          exit 0
        fi
      fi
    done
    exit 0
    ;;
esac
exit 0
