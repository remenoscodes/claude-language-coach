# claude-language-coach

Ambient language coaching for [Claude Code](https://code.claude.com). Learn languages through your daily coding sessions with contextual grammar corrections, vocabulary suggestions, and false friend alerts.

## How it works

Install the plugin and start coding. The plugin auto-detects when you're writing in a non-native language and provides lightweight coaching at the end of responses. No configuration required.

### Skills

| Skill | Type | Description |
|-------|------|-------------|
| `language-coaching` | Background | Auto-detects non-native writing, appends coaching blocks |
| `/claude-language-coach:lang` | On-demand | Full session review of your language usage |
| `/claude-language-coach:setup` | On-demand | Interactive setup to customize your preferences |

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

That's it. The plugin works immediately with smart defaults:
- Auto-detects your native language from writing patterns
- Coaches at `normal` intensity (~1 correction per 3-5 messages)
- Supports any language pair

### Customize (optional)

Run the interactive setup to fine-tune your preferences:

```
/claude-language-coach:setup
```

This guides you through choosing your native language, target languages, intensity levels, and sets up progress tracking.

### Manual (standalone)

Clone the repo and copy skills into your personal Claude config:

```bash
git clone https://github.com/remenoscodes/claude-language-coach.git
cp -r claude-language-coach/skills/* ~/.claude/skills/
```

With manual installation, skills use short names (`/lang`, `/setup` instead of `/claude-language-coach:lang`, `/claude-language-coach:setup`).

### Local development

Test the plugin without installing:

```bash
claude --plugin-dir ./claude-language-coach
```

### Skills reference (plugin install)

| Action | Command |
|--------|---------|
| Session review (English) | `/claude-language-coach:lang en` |
| Session review (Spanish) | `/claude-language-coach:lang es` |
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
  - code: es
    level: beginner
    intensity: intensive
```

Or run `/claude-language-coach:setup` to create this interactively.

### Supported options

| Field | Values | Description |
|-------|--------|-------------|
| `native_language` | Any language code | Your mother tongue (used for explanations) |
| `code` | `en`, `es`, `fr`, `de`, `it`, `ja`, etc. | Target language to coach |
| `level` | `beginner`, `intermediate`, `advanced` | Your current level |
| `intensity` | `quiet`, `normal`, `intensive` | How often coaching appears |

### Intensity levels

- **`quiet`** — Only flags errors that cause ambiguity. ~1 correction per 10 messages.
- **`normal`** (default) — Grammar patterns, idioms, false friends. ~1 per 3-5 messages. Skips obvious typos.
- **`intensive`** — Feedback on nearly every message. Vocabulary, register, all patterns.

## Progress tracking

The plugin can track your patterns over time using memory files stored globally at `~/.claude/coaching/`. This means your language progress persists across all projects.

Run `/claude-language-coach:setup` to set this up automatically, or create the files manually:

```bash
mkdir -p ~/.claude/coaching
```

Each language gets its own file (e.g., `english-coaching.md`, `spanish-coaching.md`). Templates for [English](skills/lang/templates/english-coaching.md) and [Spanish](skills/lang/templates/spanish-coaching.md) are available in the repo.

The plugin reads and updates these files across sessions, tracking:
- Recurring grammar patterns
- Native language interference
- False friends encountered in context
- Vocabulary acquired through work sessions

## Design principles

1. **Task first** — You're here to code, not to take a language class
2. **Zero friction** — Works immediately after install, no config required
3. **Pattern over incident** — Recurring mistakes get flagged, one-off typos don't
4. **Explain the why** — Brief explanations help you learn the rule, not just the fix
5. **Celebrate progress** — When a recurring error stops appearing, the system notes it
6. **Cross-language awareness** — Especially alert to false friends between similar languages (e.g., Portuguese ↔ Spanish)

## Contributing

Contributions welcome. Some areas that could use help:

- Templates for additional languages (French, German, Italian, Japanese, etc.)
- Better heuristics for detecting code-switching vs intentional language use
- Integration with spaced repetition concepts

## License

MIT
