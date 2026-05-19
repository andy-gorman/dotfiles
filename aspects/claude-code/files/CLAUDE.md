# Claude Personal Preferences

## Code Editing Rules

- When editing code, always make complete edits in a single tool call to avoid linter stripping unused imports. Never split related changes (e.g., imports and their usage) across multiple edit operations.
- If the Edit tool fails, reread the file and retry with corrected content. Do NOT fall back to sed, awk, or Python scripts to edit files. If still stuck after one retry, ask the user how to proceed.

## Git Rules

- Never run `git commit`. The user writes their own commit messages and commits their own work.

## Testing Rules

- Don't re-run tests after trivial changes (comments, whitespace, formatting) that cannot affect runtime behavior.
