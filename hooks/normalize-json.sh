#!/bin/bash
# ZEC Hook JSON Normalizer
# Converts Claude Code camelCase fields to snake_case for zec binary compatibility.
# Also injects required fields (session_id, cwd, hook_event_name) if missing.
# Usage: source this file, then call normalize_hook_input <event_name> <file>

normalize_hook_input() {
	local event_name="$1"
	local input_file="$2"

	# Convert camelCase JSON keys to snake_case
	sed -i \
		-e 's/"sessionId"/"session_id"/g' \
		-e 's/"hookEventName"/"hook_event_name"/g' \
		-e 's/"projectDir"/"project_dir"/g' \
		-e 's/"toolName"/"tool_name"/g' \
		-e 's/"toolInput"/"tool_input"/g' \
		-e 's/"toolOutput"/"tool_output"/g' \
		-e 's/"toolResponse"/"tool_response"/g' \
		-e 's/"agentType"/"agent_type"/g' \
		-e 's/"agentName"/"agent_name"/g' \
		-e 's/"agentId"/"agent_id"/g' \
		-e 's/"taskId"/"task_id"/g' \
		-e 's/"taskSummary"/"task_summary"/g' \
		-e 's/"tasksSummary"/"tasks_summary"/g' \
		-e 's/"lastAssistantMessage"/"last_assistant_message"/g' \
		-e 's/"agentTranscriptPath"/"agent_transcript_path"/g' \
		-e 's/"isInterrupt"/"is_interrupt"/g' \
		-e 's/"configPath"/"config_path"/g' \
		-e 's/"filePathOrNew"/"file_path_or_new"/g' \
		"$input_file"

	# Build a prefix of missing required fields
	local prefix=""

	# Inject hook_event_name if missing
	if [ -n "$event_name" ] && ! grep -q '"hook_event_name"' "$input_file"; then
		prefix="${prefix}\"hook_event_name\":\"$event_name\","
	fi

	# Inject session_id if missing (use CLAUDE_SESSION_ID env or "unknown")
	if ! grep -q '"session_id"' "$input_file"; then
		local sid="${CLAUDE_SESSION_ID:-unknown}"
		prefix="${prefix}\"session_id\":\"$sid\","
	fi

	# Inject cwd if missing (use CLAUDE_PROJECT_DIR or pwd)
	if ! grep -q '"cwd"' "$input_file"; then
		local cwd="${CLAUDE_PROJECT_DIR:-$(pwd)}"
		# Escape backslashes for JSON
		cwd="${cwd//\\/\\\\}"
		prefix="${prefix}\"cwd\":\"$cwd\","
	fi

	# Apply prefix if any fields were injected (use printf+read to avoid sed path issues)
	if [ -n "$prefix" ]; then
		local content
		content=$(<"$input_file")
		printf '%s' "{${prefix}${content#\{}" > "$input_file"
	fi
}
