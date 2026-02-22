---
name: setup
description: Interactive setup for language coaching preferences
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

Ask if the user wants progress tracking across sessions. If yes, create the coaching memory file(s) in a global directory so progress persists across all projects.

The memory file path follows: `~/.claude/coaching/{language}-coaching.md`

Create the directory if it doesn't exist: `mkdir -p ~/.claude/coaching`

Create the file with this structure for **English**:

```markdown
# English Coaching — {User Name}

Native language: {native_language}
Level: {level}
Active since: {today's date}

## Recurring Patterns

### Grammar
### Spelling
### Native Language Interference
### Word Choice
### Prepositions

## Vocabulary Acquired in Context
## False Friends Log
## Session History
```

For **Spanish**, use this structure:

```markdown
# Spanish Coaching — {User Name}

Native language: {native_language}
Level: {level}
Active since: {today's date}

## Recurring Patterns

### Grammar
### Spelling
### Native Language Interference
### Register

## False Friends Log
## Vocabulary Acquired in Context
## Session History
```

For **other languages**, follow the English structure but adapt sections to the language's specific challenges (e.g., add "Kanji" for Japanese, "Cases" for German, "Gender" for French).

Fill in all placeholders with the user's actual data.

### 6. Confirm

Summarize what was configured and tell the user:
- Coaching is now active (no restart needed for config changes)
- They can adjust settings by editing the config section or running this setup again
- Use the `/lang` skill (namespaced as `/claude-language-coach:lang` if installed as plugin) for on-demand session reviews
