#!/bin/bash
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
USED=$(echo "$input" | jq -r '[.context_window.current_usage | .input_tokens, .output_tokens, .cache_creation_input_tokens, .cache_read_input_tokens] | map(. // 0) | add')


echo "$input" > /tmp/claude-statusline-debug.json

# Format token counts as human-readable (e.g., 150k, 1.0M)
format_tokens() {
  local n=$1
  if (( n >= 1000000 )); then
    printf "%.1fM" "$(echo "scale=1; $n / 1000000" | bc)"
  elif (( n >= 1000 )); then
    printf "%dk" "$(( n / 1000 ))"
  else
    printf "%d" "$n"
  fi
}

USED_FMT=$(format_tokens "$USED")
echo "[$MODEL] ${USED_FMT} (${PCT}%) context"
