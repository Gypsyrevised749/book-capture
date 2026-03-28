---
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Agent, AskUserQuestion
argument-hint: "<pdf-path> <BookID> [--dpi 200]"
description: "Capture book from PDF file, OCR, and generate structured Markdown"
---

# PDF Book Capture

Source is pre-selected: **pdf** (image-based/scanned PDF via Poppler pdftoppm).

Follow the full pipeline in `${CLAUDE_PLUGIN_ROOT}/commands/capture.md` with source = `pdf`. Skip the platform selection step.

**PDF-specific notes:**
- Requires Poppler: `brew install poppler` (provides pdftoppm, pdfinfo, pdftotext)
- Checks for embedded text — use `--force` to proceed with image-based PDFs that also have embedded text
- Encrypted PDFs must be decrypted first: `qpdf --decrypt input.pdf output.pdf`
- `--dpi`: 150 (fast), 200 (balanced, default), 300 (high quality)

```bash
node "${CLAUDE_PLUGIN_ROOT}/scripts/capture-pdf.mjs" "<pdf-path>" <BookID> [--dpi 200] --output-dir "<OUTPUT_DIR>"
```
