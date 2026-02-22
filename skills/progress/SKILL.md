---
name: progress
description: Longitudinal language learning progress report with metrics, trends, and insights
argument-hint: "[en|es|fr|it|de|ja|ko|nl|all]"
disable-model-invocation: true
---

# Language Coaching — Progress Report

Generate a longitudinal progress report for the user's language learning journey. This is a **read-only analytics** skill — it does NOT modify coaching files, analyze conversation messages, or generate coaching blocks.

## Target Language

The target language is: `$ARGUMENTS` (default to `all` if empty or not specified).

Supported values: `en`, `es`, `fr`, `it`, `de`, `ja`, `ko`, `nl`, `all`.

If the argument is not recognized, respond: "Unknown language code: `{arg}`. Supported: en, es, fr, it, de, ja, ko, nl, all."

## Instructions

1. Parse the language argument
2. Determine configured languages by reading the `# Language Coaching Config` section from the user's CLAUDE.md
3. For each target language:
   a. **Read** `~/.claude/coaching/{language}-coaching.json` using the Read tool
   b. If JSON missing but `.md` exists: tell the user — "Run `/lang {code}` first to migrate to structured format, then re-run `/progress`."
   c. If neither file exists: tell the user — "No coaching data for {language}. Start a session or run `/claude-language-coach:setup`."
   d. If JSON exists: generate the full report below
4. For `all` mode: generate a per-language report for each configured language, then a cross-language summary at the end

## CRITICAL RULES

- **READ-ONLY**: Never write to or modify any file. No JSON updates, no MD regeneration, no session tracking.
- **No conversation analysis**: Do not scan user messages for language errors. This is purely historical analytics.
- **No coaching blocks**: Do not append correction, teaching, immersion, or SRS review blocks.
- **Data as-is**: Report the data from the JSON files exactly. Do not infer corrections or create new patterns.

## Flag Mapping

- `en` → 🇬🇧 English
- `es` → 🇪🇸 Español
- `fr` → 🇫🇷 Français
- `de` → 🇩🇪 Deutsch
- `it` → 🇮🇹 Italiano
- `ja` → 🇯🇵 日本語
- `ko` → 🇰🇷 한국어
- `nl` → 🇳🇱 Nederlands

## Report Format

Generate the following sections in order. Omit a section only when noted.

### Section 1: Header

```
{flag} {Language} — Progress Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: {level} | Active since: {active_since} | Sessions: {stats.total_sessions}
```

### Section 2: Overview (always shown)

```
## Overview
- Learning {language} since {active_since} ({N days/weeks/months ago})
- {stats.total_sessions} coaching sessions across {count unique projects in sessions} project(s)
- {stats.total_corrections} corrections | {stats.patterns_active} active patterns | {stats.patterns_resolved} resolved
- {stats.vocabulary_size} vocabulary terms acquired
```

Calculate time elapsed from `active_since` to today. Use "today" if same day, "N days" if < 7, "N weeks" if < 30, "N months" otherwise.

Count unique projects from `sessions[].project` values (excluding duplicates).

### Section 3: Pattern Analysis (shown when patterns array is non-empty)

```
## Pattern Analysis

### Active Patterns ({count where resolved=false})
| Pattern | Type | Corrections | First Seen | Last Seen | SRS Status |
|---------|------|-------------|------------|-----------|------------|
```

Sort by `times_corrected` descending (most persistent first). For SRS Status column:
- If `next_review` is not null: show "Due: {date} ({interval_days}d, ease {ease_factor})"
- If `next_review` is null: show "—"

```
### By Type
```

Group patterns by `type`. For each type: count patterns and sum `times_corrected`. Show as:
- `{type}: {count} pattern(s) ({sum} corrections) — {percentage}% of total`

Sort by sum descending. Calculate percentage as `sum / stats.total_corrections * 100`.

```
### Most Persistent
```

Show top 3 patterns by `times_corrected` (skip if fewer than 1):
```
1. **{native_form}** — {times_corrected} corrections, {times_correct_since_last_error} correct usages
   {explanation}
```

```
### Resolved Patterns ({count where resolved=true})
```

If resolved > 0: show table with `native_form`, `target_correction`, `times_corrected`, `last_correct_usage` (as resolution date).

If resolved == 0: show "No patterns resolved yet. Patterns resolve after 21+ days of correct usage with 5+ consecutive correct uses."

### Section 4: SRS Status (shown when any pattern has non-null next_review)

```
## SRS (Spaced Repetition)

### Due for Review
```

List patterns where `next_review <= today` and `resolved=false`, sorted by `next_review` ascending:
```
- **{native_form}** — {overdue_days} day(s) overdue (due: {next_review}, interval: {interval_days}d, ease: {ease_factor})
```

If `next_review == today`: show "due today" instead of "0 day(s) overdue".

If none due: show "No reviews due today."

```
### Upcoming Reviews
```

List patterns where `next_review > today` and `resolved=false`, sorted by `next_review` ascending:
```
- **{native_form}** — due {next_review} (interval: {interval_days}d)
```

If none upcoming: show "No upcoming reviews scheduled."

```
### SRS Health
- Patterns under SRS: {count with non-null next_review and resolved=false}
- Average ease factor: {mean of ease_factor, rounded to 2 decimals}
- Interval range: {min interval_days}d – {max interval_days}d
```

If no patterns have SRS fields activated: show "SRS will activate after your first pattern correction." instead of the whole section.

### Section 5: Vocabulary (shown when vocabulary array is non-empty)

```
## Vocabulary ({vocabulary array length} terms)

| Term | POS | Translation | Taught | Shown | Used |
|------|-----|-------------|--------|-------|------|
```

For each vocabulary entry, extract fields with fallbacks for legacy schema:
- Term: `target_term` or `term`
- POS: `part_of_speech` or `pos`
- Translation: `source_term` or `translation_en` or `translation_ptbr`
- Taught: `first_taught` (short date format)
- Shown: `times_shown`
- Used: `times_used_by_user` or 0

Sort by `first_taught` descending (newest first).

```
### Acquisition Rate
- {vocabulary_size / total_sessions} terms per session (avg)
```

If `total_sessions` is 0, show "—" instead of dividing by zero.

If vocabulary array is empty: show "No vocabulary taught yet." and explain based on mode:
- If mode is `corrective`: "Your {language} mode is `corrective` — only mistakes are corrected. Switch to `both` for vocabulary teaching."
- If mode is `active` or `both`: "Vocabulary will be acquired through active teaching and immersion blocks over time."

### Section 6: Session Timeline (shown when sessions array is non-empty)

```
## Session Timeline

### Recent Sessions
| Date | Project | Corrections | Vocab Taught | SRS Reviews | Notes |
|------|---------|-------------|-------------|-------------|-------|
```

Show the last 10 sessions from the `sessions` array (sorted by `date` descending). For each session:
- Corrections: length of `patterns_addressed`
- Vocab Taught: length of `vocabulary_taught`
- SRS Reviews: `srs_reviews`
- Notes: truncate `notes` to 40 chars if longer

If more than 10 sessions: add "(showing last 10 of {N} sessions)" below the table.

```
### Activity
- Sessions this week: {count where date is within current ISO week}
- Sessions this month: {count where date is within current month}
- Current streak: {consecutive calendar days with sessions, counting back from most recent} day(s)
- Longest streak: {max consecutive calendar days with sessions} day(s)
```

For streak calculation: check consecutive dates in the `sessions` array (each date counts once regardless of multiple entries). Work backward from the most recent session date. If only 1 session exists, streak is "1 day".

If current streak equals longest streak, omit "Longest streak" line.

### Section 7: Insights (always shown)

```
## Insights
```

Generate 3-5 actionable insights based on the data. Choose from these templates (in priority order):

1. **Weakest pattern type** (when patterns exist): Identify the type with the highest total corrections. "**Weakest area**: {type} ({sum} of {total} corrections, {pct}%). {brief advice}."

2. **Native interference** (when patterns of type `interference`, `false_friend`, or `spelling` with L1 influence exist): "**Native interference**: {count} patterns show direct {native_language} influence. {brief explanation of why this is normal for their level}."

3. **SRS trajectory** (when SRS patterns exist): Comment on SRS state — all new (interval=1d), progressing (mixed intervals), or nearing resolution (interval >= 14d).

4. **Vocabulary-correction balance** (when one side is 0): If vocabulary is 0 but patterns > 0, suggest mode change. If patterns are 0 but vocabulary > 0, celebrate clean usage.

5. **Session frequency** (when sessions > 3): Comment on regularity. Daily sessions accelerate SRS. Gaps reset momentum.

6. **Resolution progress** (when any pattern has `times_correct_since_last_error >= 3`): Highlight patterns close to resolving.

7. **Early stage** (when total_sessions < 5): "**Getting started**: {N} sessions so far. Patterns build naturally with daily use. First resolutions typically happen after 3-4 weeks."

8. **Immersion active** (when the language config has `immersion: phrase` or `immersion: sentence`): Note that immersion mode is active and contributing to vocabulary acquisition.

Rules:
- Maximum 5 insights per language
- Be encouraging about progress, honest about persistent patterns
- Use data to support each insight (cite numbers)
- Do not repeat information already visible in the tables above — add interpretation

Close the report with:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Cross-Language Summary (for `all` mode only)

After all individual language reports, add:

```
## Cross-Language Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Language | Level | Sessions | Patterns (active/resolved) | Vocabulary | Last Active |
|----------|-------|----------|---------------------------|------------|-------------|
```

One row per configured language. `Last Active` = `stats.last_session` or "never" if null.

## Important

- This is a PURE ANALYTICS skill — no corrections, no teaching, no file writes
- Focus on longitudinal trends, not single-session observations
- All dates displayed in short format (e.g., "Feb 22") for readability
- When data is sparse, acknowledge it honestly and set expectations
- Use tables for structured data, prose for insights
