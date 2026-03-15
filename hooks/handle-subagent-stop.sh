#!/bin/bash
# zec SubagentStop Hook — delegates to .zec/bridge/verify-deliverables.mjs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
BRIDGE="$PROJECT_DIR/.zec/bridge"

if [ -f "$BRIDGE/verify-deliverables.mjs" ] && command -v node >/dev/null 2>&1; then
  exec node "$BRIDGE/verify-deliverables.mjs"
fi

# Fallback: consume stdin, no-op
cat > /dev/null
exit 0
