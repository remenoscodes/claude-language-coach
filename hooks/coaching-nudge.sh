#!/usr/bin/env bash

# Language coaching nudge — injected on every user prompt via UserPromptSubmit hook.
# This reminds Claude to check for language patterns and provide coaching blocks.
# Uses hookSpecificOutput.additionalContext for silent context injection (not shown to user).

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Language coaching is active. After completing the user's task, check their message for language patterns (grammar, spelling, false friends, interference) in their configured target languages. If corrections or teaching opportunities found, append a coaching block at the end of your response. After any coaching interaction, upsert a session entry for today in the coaching JSON. Check for due SRS reviews (patterns where next_review <= today). Follow the coaching instructions in the user's CLAUDE.md under '# Language Coaching Instructions'. Memory files at ~/.claude/coaching/{lang}-coaching.json."
  }
}
EOF
exit 0
