# Known Issues

Current limitations and testing gaps in the language coach plugin.

## No Automated Behavioral Tests

CI (`validate.yml`) only validates JSON syntax and structural correctness. There are no automated tests for:
- Coaching blocks being appended correctly
- SRS scheduling logic (interval calculation, ease factor decay)
- Session upsert merging behavior
- Memory file read/write round-trip consistency
- Hook message injection

Coaching behavior is validated through manual dogfooding.

## SRS Resolution Untested

The SM-2 resolution criteria (`interval_days >= 21` AND `times_correct_since_last_error >= 5`) require at least 21 days of active use to trigger. This code path has not been exercised yet. The SRS scheduling itself (correction → next_review, correct usage → interval extension) needs validation in practice.

## Multi-Language SRS Interaction

When multiple languages have active SRS patterns with overlapping `next_review` dates, the behavior is undefined:
- Which language's SRS review takes priority?
- Can two SRS reviews fire in the same response for different languages?
- Current spec says "max 1 per response" but doesn't specify cross-language behavior.

## Session Tracking Not Yet Exercised

The `sessions` array and `stats.total_sessions` / `stats.last_session` fields exist in the schema but have not been populated by ambient coaching yet. The session upsert logic (merge by date, deduplicate arrays) is untested in practice.

## JSON/MD Sync Depends on Discipline

The dual-file architecture (JSON source-of-truth + auto-generated MD) requires that every write path regenerates the MD from JSON. If any code path writes to MD directly or skips regeneration, drift occurs. There is no automated consistency check between the two files.
