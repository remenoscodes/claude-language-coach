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
3. Check the relevant coaching memory file for known patterns
4. Provide the review in the format below
5. After the review, update the relevant memory file with any new patterns discovered

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
