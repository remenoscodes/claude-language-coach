---
name: lang
description: Full language coaching review for the current session
argument-hint: "[en|es|fr|it|de|ja|ko|all]"
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
6. For vocabulary entries reviewed or taught in this session:
   - If the entry has a `pronunciation` field: display it in the Pronunciation section
   - If the entry has NO `pronunciation` field (pre-v1.3.0 legacy): generate one following the Pronunciation Guidelines from the `language-coaching` skill, update the JSON entry with the new field, and display it
7. Provide the review in the format below
8. After the review, **write** the updated JSON file
9. **Regenerate** the markdown file from the JSON (follow the Markdown Regeneration format from the language-coaching skill)
10. Add a new entry to the `sessions` array with: `date`, `project` (if identifiable), `patterns_addressed`, `new_patterns`, `patterns_correct`, `vocabulary_used`, and `notes`
11. Recalculate the `stats` object: `total_sessions`, `total_corrections` (sum of all pattern `times_corrected`), `patterns_resolved`, `patterns_active`, `vocabulary_size`, `last_session`

## Migration Protocol (md-to-json)

When a `.md` memory file exists but no `.json` companion:

1. Read the markdown file
2. Parse each section and extract patterns:
   - Under "### Grammar", "### Spelling", etc.: extract each bullet as a pattern
   - Under "## False Friends Log": extract as `false_friend` type patterns
   - Under "## Vocabulary Acquired in Context": extract as vocabulary entries
   - Under "## Session History": extract as session entries
3. For each extracted pattern, create an entry following the Pattern Object Schema from the `language-coaching` skill:
   - Generate an `id` slug as `{type}-{kebab-case-2-4-word-description}` — NEVER use integer IDs
   - Set `first_seen` and `last_seen` to today (exact dates not recoverable from freeform markdown)
   - Set `times_corrected` to 1 (minimum, since it was recorded)
   - Set `resolved` to false
   - Include ALL required fields: `native_form`, `target_correction`, `explanation`, `examples` (array), `times_correct_since_last_error: 0`, `last_correct_usage: null`
   - Include SRS fields: `next_review: null`, `interval_days: null`, `ease_factor: null`
   - False friends go in the `patterns` array with `type: "false_friend"` — do NOT create a separate `false_friends` key
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

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag pronunciation traps relevant to the user's native_language → English]

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

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag pronunciation traps relevant to the user's native_language → Spanish]

## Register & Formality
[tu vs usted, voseo awareness if relevant]

## Progress Notes
[Compare with known patterns from memory file]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Format for French (`fr`)

```
🇫🇷 Français — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[Articles & gender, partitive, verb conjugation, subjunctive triggers]

## Gender
[Noun gender errors, adjective agreement — le/la confusion]

## False Friends (native → fr)
[Native-French false cognates detected in context]
[Critical for pt-BR: attendre/atender, entretenir/entreter, assister/assistir]

## Vocabulary
[Words used correctly — reinforce. Suggest alternatives.]

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag: liaison rules, nasal vowels, silent final consonants]

## Prepositions
[à/de/en/dans patterns, country prepositions (en/au/aux)]

## Progress Notes
[Compare with known patterns from memory file]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Format for Italian (`it`)

```
🇮🇹 Italiano — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[Articles (il/lo/la/i/gli/le), auxiliary choice (essere vs avere), verb conjugation]

## Spelling & Double Consonants
[Double consonant errors — critical in Italian: anno/ano, penna/pena]
[Accent placement: è vs é]

## False Friends (native → it)
[Native-Italian false cognates detected in context]
[CRITICAL for pt-BR: extremely high mutual intelligibility = frequent traps]
[e.g., esperto, caldo, burro, camera, guardare, salire]

## Vocabulary
[Words used correctly — reinforce. Suggest alternatives.]

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag: double consonant length, open/closed vowels, gl/gn sounds]

## Verb Conjugation
[Passato prossimo vs imperfetto, congiuntivo, irregular verbs]

## Progress Notes
[Compare with known patterns from memory file]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Format for German (`de`)

```
🇩🇪 Deutsch — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[Verb position (V2 rule, subordinate clause verb-final), modal verbs, separable prefixes]

## Cases
[Nominativ/Akkusativ/Dativ/Genitiv errors, preposition + case requirements]
[Two-way prepositions: in, an, auf, über, unter, vor, hinter, neben, zwischen]

## Gender & Articles
[der/die/das errors, article declension across cases]
[Compound noun gender (follows last component)]

## False Friends (native → de)
[Native-German false cognates detected in context]
[e.g., en "gift" ≠ de "Gift" (poison), en "become" ≠ de "bekommen" (receive)]

## Vocabulary
[Words used correctly — reinforce. Suggest alternatives.]

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag: ch sounds, Umlauts, final devoicing, word stress in compounds]

## Word Order
[V2 violations, subordinate clause verb position, TeKaMoLo]

## Progress Notes
[Compare with known patterns from memory file]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Format for Japanese (`ja`)

```
🇯🇵 日本語 — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[Particle usage, verb conjugation, sentence structure (SOV)]

## Particles
[は/が, に/で, を/が with potential verbs, compound particles]

## Keigo (Honorifics)
[丁寧語/尊敬語/謙譲語 usage, appropriate register for context]

## False Friends
[和製英語 (wasei-eigo) that differ from actual English/native language usage]
[e.g., マンション = apartment, サービス = free/complimentary]

## Vocabulary
[Words used correctly — reinforce. Suggest alternatives.]

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag: pitch accent, long vowels, geminate consonants (っ)]

## Writing System
[Kanji readings, hiragana/katakana usage, common kanji errors]

## Progress Notes
[Compare with known patterns from memory file]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Review Format for Korean (`ko`)

```
🇰🇷 한국어 — Session Review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Grammar Patterns
[Particle usage, verb conjugation, sentence structure (SOV), connective endings]

## Particles
[은/는 vs 이/가, 에 vs 에서, object marker 을/를]

## Honorifics
[Speech levels (합쇼체/해요체/해체), -(으)시- infix, special honorific vocabulary]

## False Friends
[Konglish (콩글리시) terms that differ from English]
[Sino-Korean words with different usage than Japanese/Chinese cognates]

## Vocabulary
[Words used correctly — reinforce. Suggest alternatives.]

## Pronunciation
[For vocabulary terms taught this session, show 🔊 native_language approximations]
[Flag: consonant sound changes, 받침 rules, vowel distinctions]

## Hangul Spelling
[받침 errors, sound change rules (nasalization, palatalization), common traps]

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
