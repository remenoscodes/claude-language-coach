# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-02-22

### Added
- Configurable `mode` per language: `corrective`, `active`, or `both` (default)
- Setup skill asks for coaching mode during interactive configuration
- Mode descriptions in setup: corrective (fix mistakes), active (teach from context), both (recommended)

### Changed
- Activation logic checks `mode` field to determine which coaching modes are enabled per language
- Config example updated to show `mode` field
- Smart defaults include `mode: both` when not specified

## [1.1.0] - 2026-02-22

### Added
- **Active Teaching Mode**: proactively teaches target language vocabulary from conversation context, even when user writes in another language
- Full micro-lesson block format: translation, part of speech, contextual sentence, grammar note, false friend warning
- Vocabulary Object Schema with tracking (times shown, times used by user, false friend warnings)
- Active teaching memory protocol (vocabulary entries persisted in JSON, rendered in markdown)
- Selection criteria for teaching terms: false friend traps > domain verbs > technical nouns > expressions > general
- Dual-mode coaching: corrections AND active teaching run simultaneously, both controlled by intensity level

### Changed
- Intensity levels now define frequency for both correction and active teaching
- Activation section rewritten to describe corrective mode and active teaching mode separately
- Trigger rules split into Correction Triggers and Active Teaching Triggers
- Markdown regeneration includes richer vocabulary section (examples, false friend warnings, usage counts)
- Key Principles expanded: contextual relevance, avoid vocabulary flooding

## [1.0.1] - 2026-02-22

### Fixed
- Pattern IDs now enforced as typed slugs (`grammar-didnt-plus-past`) instead of integers
- SRS fields (`next_review`, `interval_days`, `ease_factor`) and positive tracking fields (`times_correct_since_last_error`, `last_correct_usage`) now required in every pattern entry
- False friends must go in `patterns` array with `type: "false_friend"` — no separate `false_friends` key allowed
- Added explicit Pattern Object Schema to ambient coaching skill
- Setup and lang skills reference canonical schema for consistency

## [1.0.0] - 2026-02-22

### Added
- Ambient language coaching skill (background, auto-activated)
- On-demand session review skill (`/lang`)
- Interactive setup skill (`/setup`)
- Zero-config mode with smart defaults (auto-detects native language)
- Support for multiple target languages with per-language intensity and level
- Global progress tracking via `~/.claude/coaching/` memory files
- Structured JSON memory format (`{language}-coaching.json`) as source of truth
- Pattern tracking with typed IDs, correction counts, timestamps, and examples
- Vocabulary tracking with context, category, and usage counts
- Structured session history with pattern references
- Aggregate stats object (sessions, corrections, resolved/active patterns, vocabulary size)
- SRS-ready fields (next_review, interval_days, ease_factor) — null until SRS activates
- Markdown regeneration from JSON (human-readable companion, always in sync)
- Migration protocol for existing markdown-only memory files
- JSON templates for English and Spanish
- Templates for English and Spanish coaching memory files
- Flag emoji indicators per language
- Three intensity levels: quiet, normal, intensive
- Three proficiency levels: beginner, intermediate, advanced
- Plugin marketplace support for easy installation
- Manual installation option via git clone
