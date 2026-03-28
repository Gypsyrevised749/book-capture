---
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Agent, AskUserQuestion
argument-hint: "<BookID> [--horizontal] [--max-pages 500]"
description: "Capture book from Mac Kindle app, OCR, and generate structured Markdown"
---

# Mac Kindle Book Capture

Source is pre-selected: **kindle** (Mac Kindle app).

Follow the full pipeline in `${CLAUDE_PLUGIN_ROOT}/commands/capture.md` with source = `kindle`. Skip the platform selection step.

**Kindle-specific notes:**
- App name is `Amazon Kindle` (not `Kindle`)
- Uses **Page Down** key for navigation (arrow keys don't work)
- Script sends Escape to dismiss startup dialogs
- Remind user: open the book in Amazon Kindle app to the first page, ensure Accessibility permission

```bash
node "${CLAUDE_PLUGIN_ROOT}/scripts/capture-kindle-mac.mjs" <BookID> [--horizontal] --output-dir "<OUTPUT_DIR>"
```
