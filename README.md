# claude-language-coach

[![Version](https://img.shields.io/github/v/release/remenoscodes/claude-language-coach?label=version)](https://github.com/remenoscodes/claude-language-coach/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-plugin-7C3AED)](https://code.claude.com)
[![Languages](https://img.shields.io/badge/languages-8-green)](https://github.com/remenoscodes/claude-language-coach)

Ambient language coaching for [Claude Code](https://code.claude.com). Learn languages through your daily coding sessions with contextual grammar corrections, vocabulary suggestions, false friend alerts, pronunciation guidance, and spaced repetition reviews.

## How it works

Install the plugin and run `/claude-language-coach:setup`. The setup writes coaching instructions to your CLAUDE.md (always in Claude's context) and a lightweight hook nudges Claude on every prompt. Result: ambient coaching that fires on every response.

### Architecture

The plugin uses a three-layer design for reliable ambient coaching:

```
CLAUDE.md (always in context)          UserPromptSubmit hook (every prompt)
┌─────────────────────────┐           ┌──────────────────────────────┐
│ Config + Instructions    │           │ Short nudge: "coaching is    │
│ (~80 lines)              │           │ active, check for patterns"  │
└──────────┬──────────────┘           └──────────────┬───────────────┘
           └──────────── Claude sees both ────────────┘
                              │
                   ┌──────────▼──────────┐
                   │ Coaching blocks at  │
                   │ end of responses    │
                   └─────────────────────┘

language-coaching skill (500+ lines) ← detailed reference, invoked on demand
```

- **CLAUDE.md** carries config + condensed coaching rules. Always loaded into context.
- **UserPromptSubmit hook** fires a silent nudge on every prompt, reinforcing coaching behavior.
- **language-coaching skill** holds full schemas, SM-2 algorithm spec, pronunciation tables. Referenced when Claude needs detail.

### Skills

| Skill | Type | Description |
|-------|------|-------------|
| `language-coaching` | Reference | Detailed schemas, pronunciation tables, SRS algorithm (invoked on demand) |
| `/claude-language-coach:lang` | On-demand | Full session review of your language usage |
| `/claude-language-coach:setup` | On-demand | Interactive setup — writes config + instructions to CLAUDE.md |

### Example

You're working on a feature and write:

> "check this latest message, it hasn't any error?"

Claude answers your question normally, then appends:

`🇬🇧 English ─────────────────────────────────────`
**"it hasn't any error"** — **"doesn't it have any errors"** — In English, *have* as a main verb needs the *do* auxiliary for negation: *doesn't have*. Also, *any* + countable noun = plural (*errors*).
`─────────────────────────────────────────────────`

Working on a deployment and Claude teaches you the Spanish term:

`🇪🇸 Español ─────────────────────────────────────`
**desplegar** (v.) — *deploy* · 🔊 "des-ple-GAR"
"Necesitamos desplegar en producción"
📝 Regular -ar verb. Stem change: despliego, despliegas...
`─────────────────────────────────────────────────`

A pattern you corrected before comes up for review:

`🇬🇧 English review ─────────────────────────────`
💭 **didn't work** — last corrected 2026-02-20. Recall: after "didn't", use the base form (not past tense)
`─────────────────────────────────────────────────`

## Supported languages

| Language | Flag | Template | Pronunciation | Review Format | Traps |
|----------|------|----------|---------------|---------------|-------|
| English  | 🇬🇧  | ✅        | ✅ 12 mappings | ✅             | ✅ 4   |
| Spanish  | 🇪🇸  | ✅        | ✅ 10 mappings | ✅             | ✅ 4   |
| French   | 🇫🇷  | ✅        | ✅ 12 mappings | ✅             | ✅ 5   |
| Italian  | 🇮🇹  | ✅        | ✅ 14 mappings | ✅             | ✅ 5   |
| German   | 🇩🇪  | ✅        | ✅ 15 mappings | ✅             | ✅ 5   |
| Japanese | 🇯🇵  | ✅        | ✅ 9 mappings  | ✅             | ✅ 5   |
| Korean   | 🇰🇷  | ✅        | ✅ 11 mappings | ✅             | ✅ 5   |
| Dutch    | 🇳🇱  | ✅        | ✅ 13 mappings | ✅             | ✅ 6   |

All pronunciation tables are generated relative to the user's configured `native_language`. The counts above show pt-BR reference mappings; the system adapts to any native language.

## Installation

### As a plugin (recommended)

```
/plugin marketplace add remenoscodes/claude-plugin-marketplace
/plugin install claude-language-coach
```

Then run the setup to activate ambient coaching:

```
/claude-language-coach:setup
```

This writes coaching instructions to your CLAUDE.md and sets up progress tracking. The `UserPromptSubmit` hook starts working immediately after plugin install.

### Customize (optional)

The setup guides you through choosing your native language, target languages, intensity levels, coaching modes, and progress tracking. For zero-config, the plugin auto-detects your native language from writing patterns if no config is found.

### Manual (standalone)

Clone the repo and copy the plugin skills and hooks into your personal Claude config:

```bash
git clone https://github.com/remenoscodes/claude-language-coach.git
cp -r claude-language-coach/skills/* ~/.claude/skills/
cp -r claude-language-coach/hooks ~/.claude/hooks/
```

With manual installation, skills use short names (`/lang`, `/setup` instead of `/claude-language-coach:lang`, `/claude-language-coach:setup`).

After copying, run `/setup` to write the coaching instructions to your CLAUDE.md.

### Local development

Test the plugin without installing:

```bash
claude --plugin-dir ./claude-language-coach
```

### Skills reference (plugin install)

| Action | Command |
|--------|---------|
| Session review (English) | `/claude-language-coach:lang en` |
| Session review (all) | `/claude-language-coach:lang all` |
| Customize preferences | `/claude-language-coach:setup` |
| Ambient coaching | Automatic (no command needed) |

## Configuration

### Zero-config (default)

The plugin works out of the box. It auto-detects non-native patterns and coaches at `normal` intensity.

### Manual config (optional)

For precise control, add a config section to your CLAUDE.md (`~/.claude/CLAUDE.md` for global, or `.claude/CLAUDE.md` for project-specific):

```markdown
# Language Coaching Config

native_language: pt-BR
languages:
  - code: en
    level: advanced
    intensity: normal
    mode: corrective
  - code: es
    level: beginner
    intensity: intensive
    mode: both
```

**Important**: the config alone is not enough for ambient coaching. You also need the `# Language Coaching Instructions` section. Run `/claude-language-coach:setup` to generate both sections automatically.

### Supported options

| Field | Values | Description |
|-------|--------|-------------|
| `native_language` | Any language code | Your mother tongue (used for explanations and pronunciation) |
| `code` | `en`, `es`, `fr`, `de`, `it`, `ja`, `ko`, `nl` | Target language to coach |
| `level` | `beginner`, `intermediate`, `advanced` | Your current level |
| `intensity` | `quiet`, `normal`, `intensive` | How often coaching appears |
| `mode` | `corrective`, `active`, `both` | Corrections only, vocabulary only, or both (default: `both`) |

### Intensity levels

- **`quiet`** — Only flags errors that cause ambiguity. ~1 correction per 10 messages.
- **`normal`** (default) — Grammar patterns, idioms, false friends. ~1 per 3-5 messages. Skips obvious typos.
- **`intensive`** — Feedback on nearly every message. Vocabulary, register, all patterns.

### Coaching modes

- **`corrective`** — Only fix mistakes when you write in the target language. No vocabulary teaching.
- **`active`** — Teach vocabulary from conversation context. No corrections. Useful for passive exposure.
- **`both`** (default) — Corrections + active vocabulary teaching. Best for actively learning a language.

## Features

### Ambient coaching

The plugin monitors your messages for non-native patterns and appends coaching blocks at the end of responses. Three block types:

- **Correction blocks** — Fix grammar, spelling, false friends, interference patterns
- **Active teaching blocks** — Teach vocabulary from conversation context with pronunciation
- **SRS review blocks** — Lightweight reminders for previously corrected patterns

Priority: correction > teaching > SRS review. Max 1 of each type per response.

### Pronunciation coaching

Every vocabulary word taught includes a pronunciation guide using your native language's sounds. No IPA knowledge needed.

- Syllables are separated by hyphens
- The **stressed syllable** is in CAPS
- Sounds that don't exist in your native language get a brief tip (written in your native language)

Examples (for a pt-BR speaker):
- English "authentication" → `🔊 "ó-fen-ti-KEI-shon"`
- Spanish "desarrollo" → `🔊 "de-sa-RRO-lho"`
- German "Entwicklung" → `🔊 "ent-VIK-lung"`

The plugin ships with reference pronunciation tables for pt-BR speakers (96 total sound mappings across 8 languages) and adapts to any configured `native_language`.

### Spaced repetition (SRS)

When you make a mistake, the plugin schedules a review using the SM-2 algorithm:

- **First correction**: review tomorrow
- **Each correct usage**: interval grows (1d → 3d → 7d → 18d → ...)
- **Re-error**: interval resets to 1 day, ease factor decreases
- **Mastery**: when interval reaches 21+ days with 5+ consecutive correct usages, the pattern is marked resolved

Review blocks are lighter than corrections — they remind without disrupting:

```
🇬🇧 English review ─────────────────────────────
💭 didn't work — last corrected 2026-02-20. Recall: after "didn't", use the base form
─────────────────────────────────────────────────
```

### Session tracking

Every coaching interaction is automatically logged. The plugin tracks per-session:
- Patterns corrected and new patterns discovered
- Correct usages of previously problematic patterns
- Vocabulary taught and SRS reviews performed

Sessions are upserted by date — multiple coaching interactions in the same day accumulate into one session entry. Use `/claude-language-coach:lang` for a full session review with progress notes.

### Progress tracking

The plugin tracks your patterns over time using dual memory files stored globally at `~/.claude/coaching/`:

- `{language}-coaching.json` — structured source of truth
- `{language}-coaching.md` — human-readable companion (auto-regenerated from JSON)

Progress persists across all projects. Run `/claude-language-coach:setup` to set this up automatically. Templates available for all 8 languages.

## Design principles

1. **Task first** — You're here to code, not to take a language class
2. **Zero friction** — Works immediately after install, no config required
3. **Pattern over incident** — Recurring mistakes get flagged, one-off typos don't
4. **Explain the why** — Brief explanations help you learn the rule, not just the fix
5. **Celebrate progress** — When a recurring error stops appearing, the system notes it
6. **Cross-language awareness** — Especially alert to false friends between similar languages

## Contributing

Contributions welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the step-by-step guide.

Areas that could use help:
- Pronunciation tables for non-pt-BR native speakers
- SRS algorithm tuning (interval parameters, ease factor decay)
- Better heuristics for detecting code-switching vs intentional language use
- Support for additional languages beyond the current 8

## License

MIT
