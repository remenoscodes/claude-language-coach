# Plan: Add Netherlands (Dutch) Language Coaching

## Overview

Add Dutch (`nl`) as the 8th supported language in the claude-language-coach plugin. Dutch (Nederlands) uses the 🇳🇱 flag and language code `nl`.

## Dutch-Specific Language Challenges

Dutch has several unique challenges that must be reflected in the templates and review format:

- **Word Order (V2 rule)**: Like German, Dutch has V2 in main clauses and verb-final in subordinate clauses. Separable verbs split in main clauses.
- **de/het (Gender)**: Two article genders — common (`de`) and neuter (`het`). No reliable rules; largely memorization.
- **Spelling Rules**: The dt-rule (verb conjugation), open/closed syllable rules for doubled vowels/consonants, ei/ij distinction.
- **Diminutives**: Extremely productive system (-je, -tje, -pje, -etje, -kje) that changes meaning and is used far more than in other languages.
- **Separable Verbs**: Prefixes like "op-", "aan-", "uit-" split in main clauses (similar to German).
- **False Friends**: Many with German (e.g., "bellen" = to call, not to bark) and English (e.g., "slim" = smart, not thin).
- **Pronunciation**: Guttural g/ch, diphthongs (ui, eu, oe, ei/ij), the schwa-heavy rhythm.

## Files to Create

### 1. `skills/lang/templates/dutch-coaching.json`
- Copy structure from `german-coaching.json`
- Set `"language": "nl"`
- Keep all placeholders intact

### 2. `skills/lang/templates/dutch-coaching.md`
- Custom sections for Dutch challenges:
  - Grammar (V2 rule, separable verbs, er-constructions)
  - de/het (Gender & Articles)
  - Spelling (dt-rule, open/closed syllable rules, ei/ij)
  - Native Language Interference
  - Word Order (V2, subordinate clause verb-final, inversion after adverb)
  - Diminutives (-je/-tje/-pje/-etje/-kje patterns)
  - False Friends Log
  - Vocabulary Acquired in Context
  - Pronunciation Notes (g/ch, diphthongs ui/eu/oe)
  - Session History

## Files to Modify

### 3. `skills/lang/SKILL.md`
- Update argument-hint from `"[en|es|fr|it|de|ja|ko|all]"` to `"[en|es|fr|it|de|ja|ko|nl|all]"`
- Add `## Review Format for Dutch (nl)` section after Korean, before "For All Languages"
- Sections: Grammar Patterns, de/het (Gender), Spelling, False Friends, Vocabulary, Pronunciation, Word Order, Diminutives, Progress Notes

### 4. `skills/language-coaching/SKILL.md`
- Add `🇳🇱 Nederlands` to flag mapping line
- Add `### Reference: pt-BR → Dutch` pronunciation table (~12-14 sound mappings)
- Add `#### Common traps: pt-BR → Dutch` pronunciation traps section

### 5. `skills/setup/SKILL.md`
- Add `nl` to native language examples line
- Add `🇳🇱 Nederlands` to flags line

### 6. `.claude-plugin/plugin.json`
- Bump version to `1.8.0`
- Add `"dutch"` and `"netherlands"` to keywords array

### 7. `CHANGELOG.md`
- Add `## [1.8.0]` entry with:
  - Dutch language template (JSON + Markdown) with Dutch-specific sections
  - Dutch review format in `/lang` skill
  - Pronunciation reference table: pt-BR → Dutch (~12-14 sound mappings)
  - Pronunciation traps: pt-BR → Dutch
  - Updated flag mapping and plugin keywords

### 8. `README.md`
- Add Dutch row to supported languages table
- Update language count badge from 7 to 8
- Update `code` values in supported options table to include `nl`
- Update "83 total sound mappings" count
- Update "7 languages" references to "8 languages"

### 9. `CONTRIBUTING.md`
- Add Dutch to reference implementations list
- Update "All 7 planned languages" text to "All 8 planned languages"

## Git & Release

### 10. Branch, commit, and push
- Create branch `claude/add-netherlands-coaching-jk43c` if it doesn't exist
- Commit all changes with conventional commit message: `feat: add Dutch (Netherlands) language coaching`
- Push to `origin claude/add-netherlands-coaching-jk43c`

### 11. GitHub Release
- Create a GitHub release for `v1.8.0` using `gh release create`
- Tag: `v1.8.0`
- Title: `v1.8.0 — Dutch (Netherlands) language coaching`
- Release notes summarizing all additions (Dutch template, review format, pronunciation table, updated counts)

## Execution Order

1. Create the two template files (JSON + MD)
2. Modify `skills/lang/SKILL.md` (argument-hint + review format)
3. Modify `skills/language-coaching/SKILL.md` (flag mapping + pronunciation table + traps)
4. Modify `skills/setup/SKILL.md` (language code + flag)
5. Modify `.claude-plugin/plugin.json` (version bump + keywords)
6. Modify `CHANGELOG.md` (new version entry)
7. Modify `README.md` (table + counts)
8. Modify `CONTRIBUTING.md` (reference list + counts)
9. Create branch, commit, and push
10. Create GitHub release `v1.8.0` with tag and release notes
