#!/bin/bash
# zec SessionEnd Hook — 상태 검사
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/observation.sh" 2>/dev/null || { cat > /dev/null; exit 0; }

cat > /dev/null  # consume stdin

# 관측 기간이 아니면 스킵
is_observation_active || exit 0

# .zec/state/ active 모드 검사
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
zec_active=""

for f in "$PROJECT_DIR/.zec/state/"*.json; do
  [ -f "$f" ] && jq -e '.active == true' "$f" >/dev/null 2>&1 && zec_active="$zec_active $(basename "$f")"
done

exit 0
