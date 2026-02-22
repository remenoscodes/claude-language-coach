# claude-language-coach

Ambient language coaching for [Claude Code](https://code.claude.com). Learn languages through your daily coding sessions with contextual grammar corrections, vocabulary suggestions, and false friend alerts.

## How it works

This plugin adds two skills to Claude Code:

1. **`language-coaching`** (background) — Claude automatically detects when you write in a non-native language and provides lightweight feedback at the end of responses. No interruption to your work.

2. **`/claude-language-coach:lang`** (on-demand) — Run a full session review of your language usage at any time.

### Example

You're working on a feature and write:

> "how could I keep improving my english through coding sessions?"

Claude answers your question normally, then appends:

```
🇬🇧 English ──────────────────────────────────
"how could I keep improving" — mixing hypothetical "could" with ongoing
"keep improving" is a subtle mismatch. More natural:
  - "how can I keep improving..." (general advice)
  - "how could I improve..." (exploring possibilities)
─────────────────────────────────────────────────
```

## Installation

### As a plugin (recommended)

```
/plugin marketplace add remenoscodes/claude-language-coach
/plugin install claude-language-coach
```

After installation, skills are namespaced:

| Skill | Invocation |
|-------|------------|
| Session review | `/claude-language-coach:lang en` |
| Session review (Spanish) | `/claude-language-coach:lang es` |
| Session review (all) | `/claude-language-coach:lang all` |
| Ambient coaching | Automatic (no invocation needed) |

### Manual (standalone)

Clone the repo and copy skills into your personal Claude config:

```bash
git clone https://github.com/remenoscodes/claude-language-coach.git
cp -r claude-language-coach/skills/* ~/.claude/skills/
```

With manual installation, skills use short names (`/lang en` instead of `/claude-language-coach:lang en`).

### Local development

Test the plugin without installing:

```bash
claude --plugin-dir ./claude-language-coach
```

## Configuration

Add a language coaching config section to your CLAUDE.md (`~/.claude/CLAUDE.md` for global, or `.claude/CLAUDE.md` for project-specific):

```markdown
# Language Coaching Config
native_language: pt-BR
languages:
  - code: en
    level: advanced
    intensity: normal
```

Without this config section, coaching is **disabled**. The plugin requires explicit opt-in.

### Supported options

| Field | Values | Description |
|-------|--------|-------------|
| `native_language` | Any language code | Your mother tongue (used for explanations) |
| `code` | `en`, `es`, `fr`, `de`, `it`, `ja`, etc. | Target language to coach |
| `level` | `beginner`, `intermediate`, `advanced` | Your current level |
| `intensity` | `quiet`, `normal`, `intensive` | How often coaching appears |

### Intensity levels

- **`quiet`** — Only flags errors that cause ambiguity. ~1 correction per 10 messages.
- **`normal`** — Grammar patterns, idioms, false friends. ~1 per 3-5 messages. Skips obvious typos.
- **`intensive`** — Feedback on nearly every message. Vocabulary, register, all patterns.

## Progress tracking

The plugin tracks your patterns over time using memory files. Create a coaching file in your Claude project memory directory:

**English:**

```bash
mkdir -p ~/.claude/projects/<your-project>/memory
cat > ~/.claude/projects/<your-project>/memory/english-coaching.md << 'EOF'
# English Coaching

Native language: pt-BR
Level: advanced
Active since: 2026-01-01

## Recurring Patterns

### Grammar
### Spelling
### Native Language Interference
### Word Choice
### Prepositions

## Vocabulary Acquired in Context
## False Friends Log
## Session History
EOF
```

**Spanish:**

```bash
cat > ~/.claude/projects/<your-project>/memory/spanish-coaching.md << 'EOF'
# Spanish Coaching

Native language: pt-BR
Level: beginner
Active since: 2026-01-01

## Recurring Patterns

### Grammar
### Spelling
### Native Language Interference
### Register

## False Friends Log
## Vocabulary Acquired in Context
## Session History
EOF
```

Fuller templates with comments are available in the repo at [`skills/lang/templates/`](skills/lang/templates/).

## Adding a new language

1. Add the language entry to your CLAUDE.md config section
2. Create the coaching memory file (use the templates above as a starting point)
3. The coaching system picks it up immediately

## Design principles

1. **Task first** — You're here to code, not to take a language class
2. **Pattern over incident** — Recurring mistakes get flagged, one-off typos don't
3. **Explain the why** — Brief explanations help you learn the rule, not just the fix
4. **Celebrate progress** — When a recurring error stops appearing, the system notes it
5. **Cross-language awareness** — Especially alert to false friends between similar languages (e.g., Portuguese ↔ Spanish)

## Contributing

Contributions welcome. Some areas that could use help:

- Templates for additional languages (French, German, Italian, Japanese, etc.)
- Better heuristics for detecting code-switching vs intentional language use
- Integration with spaced repetition concepts

## License

MIT
