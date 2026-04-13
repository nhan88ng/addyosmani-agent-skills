#!/bin/bash
# agent-skills session start hook
# Injects the using-agent-skills meta-skill into every new session

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$(dirname "$SCRIPT_DIR")/skills"
META_SKILL="$SKILLS_DIR/using-agent-skills/SKILL.md"

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' '{"priority": "INFO", "message": "agent-skills: jq not found, skipping skill injection."}'
  exit 0
fi

if [ -f "$META_SKILL" ]; then
  CONTENT=$(cat "$META_SKILL")
  # Use jq to safely escape all special characters in the message
  jq -n \
    --arg content "$CONTENT" \
    '{"priority":"IMPORTANT","message":("agent-skills loaded. Use the skill discovery flowchart to find the right skill for your task.\n\n" + $content)}'
else
  jq -n '{"priority":"INFO","message":"agent-skills: using-agent-skills meta-skill not found. Skills may still be available individually."}'
fi
