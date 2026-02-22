---
name: setup
description: Interactive setup for language coaching preferences
argument-hint: ""
disable-model-invocation: true
---

# Language Coach — Setup

Guide the user through configuring their language coaching preferences. This creates or updates the `# Language Coaching Config` section in their CLAUDE.md.

## Steps

### 1. Ask for native language

Ask the user what their native/mother tongue is. Examples: pt-BR, es, en, fr, de, ja, zh, ko.

### 2. Ask for target languages

Ask which languages they want coaching for. For each language, ask:
- **Level**: beginner, intermediate, or advanced
- **Intensity**: quiet, normal, or intensive

Explain the intensity levels briefly:
- `quiet` — only errors that cause confusion (~1 per 10 messages)
- `normal` — grammar, idioms, false friends (~1 per 3-5 messages)
- `intensive` — feedback on nearly every message

### 3. Ask where to save config

Determine the right CLAUDE.md location:
- `~/.claude/CLAUDE.md` — global (all projects)
- `.claude/CLAUDE.md` — project-specific
- `~/CLAUDE.md` — if the user already has one here

Check if the user already has a CLAUDE.md file and suggest the best location.

### 4. Write the config

Create or append the `# Language Coaching Config` section:

```markdown
# Language Coaching Config

native_language: {their_native_language}
languages:
  - code: {lang_code}
    level: {level}
    intensity: {intensity}
```

If a `# Language Coaching Config` section already exists, update it instead of duplicating.

### 5. Create memory files (optional)

Ask if the user wants progress tracking across sessions. If yes, create the coaching memory file(s) in their project memory directory:

```
~/.claude/projects/<project>/memory/{language}-coaching.md
```

Use the templates from `skills/lang/templates/` as a starting point, filling in the placeholders with the user's actual data.

### 6. Confirm

Summarize what was configured and tell the user:
- Coaching is now active (no restart needed for config changes)
- They can adjust settings by editing the config section or running this setup again
- Use `/claude-language-coach:lang {code}` for on-demand session reviews
