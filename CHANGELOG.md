# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
