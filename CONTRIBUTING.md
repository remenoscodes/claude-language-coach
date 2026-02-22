# Contributing to claude-language-coach

Contributions welcome! The easiest way to contribute is by adding support for a new language.

## Local development

Test the plugin without installing:

```bash
git clone https://github.com/remenoscodes/claude-language-coach.git
cd claude-language-coach
claude --plugin-dir ./plugins/claude-language-coach
```

## Adding a new language template

This is the most impactful contribution. Each language needs two template files and a review format block.

### Checklist

- [ ] Create `plugins/claude-language-coach/skills/lang/templates/{language}-coaching.json`
- [ ] Create `plugins/claude-language-coach/skills/lang/templates/{language}-coaching.md`
- [ ] Add a review format block to `plugins/claude-language-coach/skills/lang/SKILL.md`
- [ ] Add flag emoji to mapping in `plugins/claude-language-coach/skills/language-coaching/SKILL.md` (if not already there)
- [ ] Add language name to `keywords` in `plugins/claude-language-coach/.claude-plugin/plugin.json`
- [ ] Update CHANGELOG.md
- [ ] Test locally with `claude --plugin-dir`

### Step by step

1. **Copy an existing template** as your starting point:
   - JSON: copy `english-coaching.json`, change `"language"` to your language code
   - Markdown: copy `english-coaching.md` or `spanish-coaching.md`

2. **Customize the markdown sections** for your language's specific challenges:
   - Spanish has "Register" (tu/usted) — your language might have "Cases" (German), "Honorifics" (Japanese), or "Tones" (Chinese)
   - The "False Friends Log" section should note which language pairs have the most traps

3. **Add a review format block** in `skills/lang/SKILL.md` following the English/Spanish pattern:
   ```
   ## Review Format for {Language} (`{code}`)

   ```
   {flag} {Language} — Session Review
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ## Grammar Patterns
   [Language-specific grammar challenges]

   ## Vocabulary
   ...

   ## Pronunciation
   ...

   ## Progress Notes
   ...
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

4. **Test** by running `claude --plugin-dir ./plugins/claude-language-coach` and having a conversation that mixes your target language

### Reference implementations

- English: [`english-coaching.md`](plugins/claude-language-coach/skills/lang/templates/english-coaching.md), [`english-coaching.json`](plugins/claude-language-coach/skills/lang/templates/english-coaching.json)
- Spanish: [`spanish-coaching.md`](plugins/claude-language-coach/skills/lang/templates/spanish-coaching.md), [`spanish-coaching.json`](plugins/claude-language-coach/skills/lang/templates/spanish-coaching.json)
- French: [`french-coaching.md`](plugins/claude-language-coach/skills/lang/templates/french-coaching.md), [`french-coaching.json`](plugins/claude-language-coach/skills/lang/templates/french-coaching.json)
- Italian: [`italian-coaching.md`](plugins/claude-language-coach/skills/lang/templates/italian-coaching.md), [`italian-coaching.json`](plugins/claude-language-coach/skills/lang/templates/italian-coaching.json)
- German: [`german-coaching.md`](plugins/claude-language-coach/skills/lang/templates/german-coaching.md), [`german-coaching.json`](plugins/claude-language-coach/skills/lang/templates/german-coaching.json)
- Japanese: [`japanese-coaching.md`](plugins/claude-language-coach/skills/lang/templates/japanese-coaching.md), [`japanese-coaching.json`](plugins/claude-language-coach/skills/lang/templates/japanese-coaching.json)
- Korean: [`korean-coaching.md`](plugins/claude-language-coach/skills/lang/templates/korean-coaching.md), [`korean-coaching.json`](plugins/claude-language-coach/skills/lang/templates/korean-coaching.json)

## Commit conventions

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` — new feature (new language template, new skill capability)
- `fix:` — bug fix
- `docs:` — documentation only
- `chore:` — maintenance (version bump, CI changes)

## Pull requests

1. Fork the repo
2. Create a branch (`feat/add-french-template`)
3. Make your changes
4. Test locally with `claude --plugin-dir`
5. Open a PR using the template
