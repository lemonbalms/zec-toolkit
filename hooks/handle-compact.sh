#!/bin/bash
# zec PreCompact Hook — 컨텍스트 예산 경고 자동 기록
# compact 발생 = 컨텍스트 부족 신호
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/observation.sh" 2>/dev/null || { cat > /dev/null; exit 0; }

cat > /dev/null  # consume stdin

# 관측 기간이 아니면 스킵
is_observation_active || exit 0

log_metric "context-warnings" "PreCompact 발생 — 컨텍스트 예산 부족으로 압축 실행"

exit 0
