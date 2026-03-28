---
vault_root: ""
captures_dir: Books/files/book-captures
entries_dir: Books/entries
default_source: kindle
default_language: JP
default_dpi: 200
---

# Book Capture Settings

Per-project configuration for the book-capture plugin.

## Fields

- `vault_root` — Absolute path to Obsidian vault root. Leave empty to auto-detect from `.obsidian/` directory.
- `captures_dir` — Relative path from vault root to captures directory. Default: `Books/files/book-captures`
- `entries_dir` — Relative path from vault root to book entries (hub files). Default: `Books/entries`
- `default_source` — Default capture source: `kindle`, `books`, `cloud`, or `pdf`
- `default_language` — Default output language: `JP` or `EN`
- `default_dpi` — Default DPI for PDF rendering: 150 (fast), 200 (balanced), 300 (high quality)
