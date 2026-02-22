# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-22

### Added
- Structured JSON memory format (`{language}-coaching.json`) as source of truth
- Pattern tracking with typed IDs, correction counts, timestamps, and examples
- Vocabulary tracking with context, category, and usage counts
- Structured session history with pattern references
- Aggregate stats object (sessions, corrections, resolved/active patterns, vocabulary size)
- SRS-ready fields (next_review, interval_days, ease_factor) — null until SRS activates
- Markdown regeneration from JSON (human-readable companion, always in sync)
- Migration protocol for existing markdown-only memory files
- JSON templates for English and Spanish

### Changed
- Memory files now use dual format: `.json` (source of truth) + `.md` (rendered view)
- Setup skill creates both JSON and markdown files
- Lang skill reads JSON first, falls back to markdown with auto-migration
- Ambient coaching skill reads JSON for pattern matching, writes structured updates

## [1.0.0] - 2026-02-22

### Added
- Ambient language coaching skill (background, auto-activated)
- On-demand session review skill (`/lang`)
- Interactive setup skill (`/setup`)
- Zero-config mode with smart defaults (auto-detects native language)
- Support for multiple target languages with per-language intensity and level
- Global progress tracking via `~/.claude/coaching/` memory files
- Templates for English and Spanish coaching memory files
- Flag emoji indicators per language (🇬🇧, 🇪🇸, 🇫🇷, 🇩🇪, 🇮🇹, 🇯🇵)
- Three intensity levels: quiet, normal, intensive
- Three proficiency levels: beginner, intermediate, advanced
- Plugin marketplace support for easy installation
- Manual installation option via git clone
