# claude-language-coach

Claude Code plugin for ambient language coaching during coding sessions. Supports 8 languages with grammar corrections, vocabulary, pronunciation, and SM-2 spaced repetition.

Inherits workspace conventions from `~/CLAUDE.md`.

## Status
- **Version**: 1.10.0
- **State**: active
- **Deploy**: Claude Code plugin via `remenoscodes/claude-plugin-marketplace`

## Stack
Claude Code plugin system: CLAUDE.md instructions, shell hooks (Bash), Markdown skills.
Memory: JSON files at `~/.claude/coaching/` with auto-generated MD companions.

## Key Commands
```bash
/claude-language-coach:setup          # Interactive setup (writes config + instructions to CLAUDE.md)
/claude-language-coach:lang en        # Session review for English
/claude-language-coach:lang all       # Session review for all languages
/claude-language-coach:progress       # Longitudinal progress report (all languages)
/claude-language-coach:progress es    # Progress report for a specific language
claude --plugin-dir ./                # Local development (test without installing)
```

## Architecture
- `hooks/coaching-nudge.sh` — UserPromptSubmit hook injecting a nudge on every prompt
- `skills/` — Four skills: `language-coaching` (reference, 500+ lines), `lang` (on-demand review), `progress` (longitudinal analytics), `setup` (interactive config)
- Three-layer design: CLAUDE.md config (~80 lines, always in context) + hook (reinforcement) + skill (detailed reference on demand)
- Dual-file memory: `{lang}-coaching.json` (source of truth) + `{lang}-coaching.md` (human-readable, auto-regenerated)
- SRS via SM-2: correction sets next_review to tomorrow, correct usage grows interval, mastery at 21d + 5 correct

## Related Projects
- `~/source/remenoscodes.claude-plugin-marketplace` — Central marketplace distributing this plugin
- `~/source/remenoscodes.launchpad` — Launch strategy (campaign: `claude-language-coach/`)
