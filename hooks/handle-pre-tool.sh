#!/bin/bash
# zec PreToolUse Context Injector + context-safety bridge
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
BRIDGE="$PROJECT_DIR/.zec/bridge"

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
cat > "$temp_file"

tool_name=$(jq -r '.tool_name // ""' < "$temp_file")

# ExitPlanMode: context-safety bridge (컨텍스트 55% 초과 시 차단)
if [ "$tool_name" = "ExitPlanMode" ] && [ -f "$BRIDGE/context-safety.mjs" ] && command -v node >/dev/null 2>&1; then
  cat "$temp_file" | node "$BRIDGE/context-safety.mjs"
  exit $?
fi

case "$tool_name" in
  Read)
    echo '{"additionalContext": "Read multiple files in parallel when possible for faster analysis."}'
    ;;
  Grep)
    echo '{"additionalContext": "Combine searches in parallel when investigating multiple patterns."}'
    ;;
  Bash)
    echo '{"additionalContext": "Use parallel execution for independent tasks. Use run_in_background for long operations."}'
    ;;
  Write|Edit)
    echo '{"additionalContext": "Verify changes work after editing. Test functionality before marking complete."}'
    ;;
  *)
    exit 0
    ;;
esac
exit 0
