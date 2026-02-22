---
name: lang
description: Full language coaching review for the current session
argument-hint: "[en|es|all]"
disable-model-invocation: true
---

# Language Coaching — Session Review

Analyze the user's messages in this session and provide detailed language coaching feedback.

## Target Language

The target language is: `$ARGUMENTS` (default to `en` if empty or not specified).

## Instructions

1. Review ALL user messages in this conversation
2. Reference the user's ACTUAL messages — quote specific phrases
3. **Read** `~/.claude/coaching/{language}-coaching.json` using the Read tool
   - If the JSON file exists: use it as the source of truth for known patterns
   - If the JSON file does NOT exist but the `.md` file does: read the `.md`, perform a best-effort migration to create the JSON (see Migration Protocol below), then proceed
   - If neither file exists: proceed without memory context, note this in the review
4. For each language issue found in the session:
   - Check if a matching pattern exists in the JSON (search by `id` slug or similar `native_form`/`target_correction`)
   - If it matches an existing pattern: flag it prominently as recurring, increment `times_corrected`, update `last_seen`
   - If it is new: create a new pattern entry in the JSON
5. For known patterns that the user got RIGHT in this session:
   - Update `last_correct_usage`, increment `times_correct_since_last_error`
   - Mention this in Progress Notes as positive reinforcement
6. Provide the review in the format below
7. After the review, **write** the updated JSON file
8. **Regenerate** the markdown file from the JSON (follow the Markdown Regeneration format from the language-coaching skill)
9. Add a new entry to the `sessions` array with: `date`, `project` (if identifiable), `patterns_addressed`, `new_patterns`, `patterns_correct`, `vocabulary_used`, and `notes`
10. Recalculate the `stats` object: `total_sessions`, `total_corrections` (sum of all pattern `times_corrected`), `patterns_resolved`, `patterns_active`, `vocabulary_size`, `last_session`

## Migration Protocol (md-to-json)

When a `.md` memory file exists but no `.json` companion:

1. Read the markdown file
2. Parse each section and extract patterns:
   - Under "### Grammar", "### Spelling", etc.: extract each bullet as a pattern
   - Under "## False Friends Log": extract as `false_friend` type patterns
   - Under "## Vocabulary Acquired in Context": extract as vocabulary entries
   - Under "## Session History": extract as session entries
3. For each extracted pattern:
   - Generate an `id` slug as `{type}-{kebab-case-2-4-word-description}`
   - Set `first_seen` and `last_seen` to today (exact dates not recoverable from freeform markdown)
   - Set `times_corrected` to 1 (minimum, since it was recorded)
   - Set `resolved` to false, all SRS fields to null
4. Create the JSON structure with `version: 1`
5. Write the JSON file
6. Regenerate the markdown from JSON (normalizes the format)
7. Proceed with the session review as normal

## Review Format for English (`en`)

```
🇬🇧 English — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[List recurring grammar issues with corrections and explanations]

## Vocabulary
[Words used correctly in context — reinforce these]
[Suggest more precise/idiomatic alternatives where applicable]

## False Friends (native → en)
[Any native language interference patterns detected]

## Idioms & Natural Phrasing
[Suggest more natural ways to express ideas that were technically
correct but sound non-native]

## Spelling
[Typos vs systematic spelling patterns — distinguish between them]

## Progress Notes
[Compare with known patterns from memory file. What improved?
What persists? New patterns discovered?]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Format for Spanish (`es`)

```
🇪🇸 Español — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[Verb conjugation, gender agreement, ser/estar, por/para, subjunctive]

## False Friends (native → es)
[Critical: native-Spanish false cognates detected in context]

## Vocabulary
[Words used correctly — reinforce. Suggest alternatives.]

## Register & Formality
[tu vs usted, voseo awareness if relevant]

## Progress Notes
[Compare with known patterns from memory file]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## For All Languages (`all`)

Provide a combined review covering all active languages from the session.
Separate each language into its own section.

## Important

- Explain the WHY behind corrections, not just the fix
- Prioritize patterns over one-off typos
- Be encouraging about correct usage, not just corrective
- Use the user's native language for explanations when helpful
