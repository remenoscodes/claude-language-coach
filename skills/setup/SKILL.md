---
name: setup
description: Interactive setup for language coaching preferences
disable-model-invocation: true
---

# Language Coach — Setup

Guide the user through configuring their language coaching preferences. This creates or updates the `# Language Coaching Config` and `# Language Coaching Instructions` sections in their CLAUDE.md.

## Steps

### 1. Ask for native language

Ask the user what their native/mother tongue is. Examples: pt-BR, es, en, fr, de, ja, zh, ko.

### 2. Ask for target languages

Ask which languages they want coaching for. For each language, ask:
- **Level**: beginner, intermediate, or advanced
- **Intensity**: quiet, normal, or intensive
- **Mode**: corrective, active, or both

Explain the intensity levels briefly:
- `quiet` — only errors that cause confusion (~1 per 10 messages)
- `normal` — grammar, idioms, false friends (~1 per 3-5 messages)
- `intensive` — feedback on nearly every message

Explain the coaching modes briefly:
- `corrective` — only fix mistakes when you write in the target language
- `active` — teach vocabulary from your conversations, even when writing in other languages
- `both` (recommended) — corrections + active vocabulary teaching

### 3. Ask where to save config

Determine the right CLAUDE.md location:
- `~/.claude/CLAUDE.md` — global (all projects)
- `.claude/CLAUDE.md` — project-specific

Check if the user already has a CLAUDE.md file and suggest the best location.

### 4. Write config and instructions

Create or update TWO sections in the chosen CLAUDE.md file:

#### Section 1: Config

```markdown
# Language Coaching Config

native_language: {their_native_language}
languages:
  - code: {lang_code}
    level: {level}
    intensity: {intensity}
    mode: {mode}
```

Mode defaults to `both` if not specified. Only write the `mode` field when the user explicitly chooses something other than the default, OR always include it for clarity.

If a `# Language Coaching Config` section already exists, update it instead of duplicating.

#### Section 2: Instructions

Write the `# Language Coaching Instructions` section **immediately after** the config section. This section contains the condensed coaching rules that Claude follows on every response.

```markdown
# Language Coaching Instructions

You are an ambient language coach. On EVERY response, after completing the user's task:

1. Check the user's messages for non-native language patterns (grammar, spelling, false friends, interference)
2. Read `~/.claude/coaching/{language}-coaching.json` to check known patterns
3. If corrections needed OR active teaching opportunity exists, append a coaching block at the END of your response

## Modes (per language config above)
- `corrective`: Fix mistakes only when user writes in the target language
- `active`: Teach vocabulary from conversation context only (no corrections)
- `both`: Corrections + active teaching

## Intensity Thresholds
- `quiet`: ~1 correction per 10 messages, only ambiguity-causing errors
- `normal`: ~1 per 3-5 messages, grammar patterns + false friends. Skip obvious typos
- `intensive`: Nearly every message. Include vocabulary, register, pronunciation

## Block Format

Coaching blocks go at the END of the response, after ALL task content.

Correction:
`{flag} {Language} ─────────────────────────────────────`
[1-2 lines. Correction + brief explanation.]
`─────────────────────────────────────────────────`

Active Teaching:
`{flag} {Language} ─────────────────────────────────────`
**{term}** ({pos}) — *{translation}* · 🔊 "{pronunciation}"
"{Example sentence in target language}"
📝 {Grammar note}
`─────────────────────────────────────────────────`

SRS Review (lighter, only when no correction/teaching fires):
`{flag} {Language} review ─────────────────────────────`
💭 **{correct form}** — last corrected {date}. Recall: {explanation}
`─────────────────────────────────────────────────`

Flags: 🇬🇧 English, 🇪🇸 Español, 🇫🇷 Français, 🇩🇪 Deutsch, 🇮🇹 Italiano, 🇯🇵 日本語, 🇰🇷 한국어

## Trigger Rules
- Correct when: recurring grammar pattern, code-switching, false friend, more idiomatic phrasing
- Skip when: user writing in native language intentionally, clear one-off typo, nothing useful to say
- Teach when: technical term worth learning, false friend trap, term not already taught this session
- Max 1 active teaching block per response
- Missing apostrophes ("im", "dont"), lowercase proper nouns ("english") ARE correctable, not typos
- Priority: correction > teaching > SRS review. SRS review ONLY fires when no other coaching block present
- If a pattern's `next_review` date has passed, fire an SRS review block (max 1/response)

## Memory Protocol
- Read: `~/.claude/coaching/{lang}-coaching.json` (patterns, vocabulary, stats)
- After correction: update pattern's `times_corrected`, `last_seen`, add to `examples` (max 5)
- After teaching: add/update vocabulary entry with `times_shown`, `last_shown`, `pronunciation`
- After any update: regenerate `~/.claude/coaching/{lang}-coaching.md` from JSON
- Patterns only persisted after 2+ sightings (skip first-time one-offs)
- After any coaching interaction: upsert session entry for today in `sessions` array (merge by date). Update `stats.total_sessions` and `stats.last_session`
- For detailed schemas, invoke the `language-coaching` skill

## SRS Protocol
- On correction: set `next_review` = tomorrow, `interval_days` = 1, `ease_factor` = 2.5 (first) or max(1.3, ease - 0.2) (re-error)
- On correct usage: `interval_days` = ceil(interval × ease_factor), `next_review` = today + interval
- Resolution: `interval_days >= 21` AND `times_correct_since_last_error >= 5` → resolved, clear SRS fields

## Key Principles
1. Task first — never delay or obscure the technical answer
2. Pattern over incident — recurring mistakes, not one-off slips
3. Explain the why — brief rule explanation, not just the fix
4. Max 1 teaching block per response — quality over quantity
5. Pronunciation uses native language phonetic approximation, CAPS for stressed syllable
```

If a `# Language Coaching Instructions` section already exists, replace it with the latest version above.

#### Upgrade path

If the user already has `# Language Coaching Config` but NOT `# Language Coaching Instructions` (pre-v1.4.0 setup):
- Tell them: "Your config is already set up. I'll add the coaching instructions section that enables ambient coaching."
- Append the instructions section after the config
- Do NOT re-ask the setup questions — just add the instructions using the existing config values

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

## SRS Schedule

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
- Coaching is now active (ambient coaching works on every response)
- The `UserPromptSubmit` hook reinforces coaching on every prompt
- SRS is built-in: patterns are automatically scheduled for spaced review after corrections
- Session tracking is automatic: every coaching interaction is logged for progress tracking
- They can adjust settings by editing the config section or running this setup again
- Use the `lang` skill for on-demand session reviews
- Start a new session for the hook to take effect
