#!/bin/bash
# JSON utility library for zec
json_get() { jq -r "$2 // \"$3\"" "$1" 2>/dev/null || echo "$3"; }
safe_jq() { echo "$2" | jq "$1" 2>/dev/null || echo '{}'; }
