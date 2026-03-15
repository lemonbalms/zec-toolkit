#!/bin/bash
# zec PostToolUseFailure Hook
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT
cat > "$temp_file"

tool_name=$(jq -r '.tool_name // ""' < "$temp_file")
echo "{\"systemMessage\": \"Tool '$tool_name' failed. Diagnose the error before retrying.\"}"
exit 0
