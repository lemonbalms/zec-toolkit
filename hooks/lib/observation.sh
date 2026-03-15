#!/bin/bash
# observation.sh — 관측 기간 메트릭 로깅 유틸리티
# 사용: source "$SCRIPT_DIR/lib/observation.sh"

OBS_DIR="${CLAUDE_PROJECT_DIR:-.}/.zec/logs/observation"
OBS_START="2026-03-15"
OBS_END="2026-04-15"

# 관측 기간 내인지 확인
is_observation_active() {
  local today
  today=$(date +%Y-%m-%d)
  [[ "$today" > "$OBS_START" || "$today" == "$OBS_START" ]] && \
  [[ "$today" < "$OBS_END" || "$today" == "$OBS_END" ]]
}

# 메트릭 로그 기록
# 사용: log_metric "runtime-conflicts" "Stop hook 이중 실행 감지"
log_metric() {
  local metric_file="$1"
  local message="$2"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  mkdir -p "$OBS_DIR"
  echo "[$timestamp] $message" >> "$OBS_DIR/$metric_file.log"
}

# 메트릭 카운트 조회
count_metric() {
  local metric_file="$1"
  if [ -f "$OBS_DIR/$metric_file.log" ]; then
    wc -l < "$OBS_DIR/$metric_file.log" | tr -d ' '
  else
    echo "0"
  fi
}
