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

### 5. Create memory files

Ask if the user wants progress tracking across sessions. If yes, create coaching memory files in a global directory so progress persists across all projects.

The memory directory is: `~/.claude/coaching/`
Create the directory if it doesn't exist: `mkdir -p ~/.claude/coaching`

For each target language, create **TWO companion files**:

#### JSON file (source of truth): `~/.claude/coaching/{language}-coaching.json`

```json
{
  "version": 1,
  "language": "{lang_code}",
  "native_language": "{native_language}",
  "level": "{level}",
  "active_since": "{today's date, YYYY-MM-DD}",
  "patterns": [],
  "vocabulary": [],
  "sessions": [],
  "stats": {
    "total_sessions": 0,
    "total_corrections": 0,
    "patterns_resolved": 0,
    "patterns_active": 0,
    "vocabulary_size": 0,
    "last_session": null
  }
}
```

**CRITICAL schema rules**:
- The top-level keys are ONLY: `version`, `language`, `native_language`, `level`, `active_since`, `patterns`, `vocabulary`, `sessions`, `stats`. Do NOT add extra keys like `false_friends`.
- False friends go in the `patterns` array with `"type": "false_friend"`.
- Each pattern entry MUST have string slug IDs in `{type}-{kebab-case}` format (e.g., `"id": "grammar-didnt-plus-past"`). NEVER use integer IDs.
- Each pattern MUST include SRS fields: `"next_review": null, "interval_days": null, "ease_factor": null`
- Each pattern MUST include tracking fields: `"times_correct_since_last_error": 0, "last_correct_usage": null`
- See the `language-coaching` skill for the full Pattern Object Schema.

#### Markdown file (human-readable): `~/.claude/coaching/{language}-coaching.md`

Generate the initial markdown from the JSON with this structure:

```markdown
# {Language} Coaching — {User Name}

Native language: {native_language}
Level: {level}
Active since: {active_since}

## Recurring Patterns

### Grammar
### Spelling
### Native Language Interference
### Word Choice
### Prepositions
### Register

## False Friends Log

## Resolved Patterns

## Vocabulary Acquired in Context

## Session History

## Stats
- Sessions: 0
- Active patterns: 0
- Resolved patterns: 0
- Vocabulary: 0 terms
- Total corrections: 0
```

For **Spanish**, adapt sections (add Register prominently, note that False Friends are critical for pt-BR↔es).
For **other languages**, adapt to the language's specific challenges (e.g., add "Kanji" for Japanese, "Cases" for German, "Gender" for French).

Fill in all placeholders with the user's actual data.

#### If memory files already exist

- If `.md` exists but no `.json`: offer to migrate. Read the markdown, extract patterns/vocabulary/sessions into JSON structure, create the JSON file, then regenerate the markdown from the JSON to normalize the format. Tell the user: "Migrated your existing coaching data to structured format."
- If both files already exist: tell the user memory is already configured and offer to reset (with confirmation).

### 6. Confirm

Summarize what was configured and tell the user:
- Coaching is now active (no restart needed for config changes)
- They can adjust settings by editing the config section or running this setup again
- Use the `lang` skill for on-demand session reviews
