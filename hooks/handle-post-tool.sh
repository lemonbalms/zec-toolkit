#!/bin/bash
# zec PostToolUse Hook — ZEC hints + bridge verifier
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
BRIDGE="$PROJECT_DIR/.zec/bridge"

# Node.js bridge가 있으면 위임 (Bash 에러 감지, <remember> 처리, Read 10회 경고)
if [ -f "$BRIDGE/post-tool-verifier.mjs" ] && command -v node >/dev/null 2>&1; then
  exec node "$BRIDGE/post-tool-verifier.mjs"
fi

# Fallback: 기본 ZEC 검증 힌트
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
cat > "$temp_file"

tool_name=$(jq -r '.tool_name // ""' < "$temp_file")

case "$tool_name" in
  Write)
    echo '{"additionalContext": "File written. Test the changes to ensure they work correctly."}'
    ;;
  Edit)
    echo '{"additionalContext": "File edited. Verify the edit was applied correctly."}'
    ;;
  *)
    exit 0
    ;;
esac
exit 0
