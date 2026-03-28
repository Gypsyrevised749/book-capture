---
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Agent, AskUserQuestion
argument-hint: "<BookTitle> [--horizontal] [--max-pages 500]"
description: "Capture book from Apple Books app, OCR, and generate structured Markdown"
---

# Apple Books Capture

Source is pre-selected: **books** (Apple Books app).

Follow the full pipeline in `${CLAUDE_PLUGIN_ROOT}/commands/capture.md` with source = `books`. Skip the platform selection step.

**Apple Books-specific notes:**
- Uses left/right arrow keys for page navigation (left = next for RTL/vertical, right = next for LTR/horizontal)
- Automatically detects Books app window via CGWindowList
- Script sends Escape to dismiss any dialogs first
- Book Title is used as the folder ID (sanitized)
- Remind user: open the book in Apple Books to the first page, ensure Accessibility permission

```bash
node "${CLAUDE_PLUGIN_ROOT}/scripts/capture-books-app.mjs" "<BookTitle>" [--horizontal] --output-dir "<OUTPUT_DIR>"
```
