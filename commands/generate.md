---
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Agent, AskUserQuestion
argument-hint: "<BookID> --title Title --author Author --category Cat --location Path"
description: "Generate structured Obsidian Markdown from existing OCR text (requires raw_text.json)"
---

# Structured Markdown Generation

Generate thematic Obsidian Markdown documents from existing OCR text. Requires `raw_text.json` to already exist.

## Setup

- Resolve vault paths from `.claude/book-capture.local.md` or auto-detect
- Parse `$ARGUMENTS` for BookID and metadata flags
- `OUTPUT_DIR` = `<CAPTURES_BASE>/<BookID>`

Verify OCR data exists:
```
Read: <OUTPUT_DIR>/raw_text.json
```

If not found, tell the user to run `/book-capture:ocr` first.

## Step 1: Gather Metadata

Parse from `$ARGUMENTS` or ask user:
- **Book Title** (required)
- **Author** (required)
- **Category** (required)
- **Location** — where topic files go (e.g., `Knowledge/Marketing/BookTitle`)
- **Language** — JP (default) or EN
- **URL** (optional)

## Step 2: Plan Thematic Structure

Read `raw_text.json`, concatenate all page text. Check for existing `structured.json` — if found, offer to reuse or regenerate.

Analyze the full text to identify **8-14 thematic categories** by information type (not original chapter order). Save to `<OUTPUT_DIR>/structured.json`.

## Step 3: Generate Topic Files

Set `LOCATION_DIR` = `<VAULT_ROOT>/<Location>`

Dispatch 3-5 parallel agents (subagent_type: `book-capture:content-writer`), each handling 2-4 themes.

Each agent writes files to `<LOCATION_DIR>/NN_ThemeName.md` with:
- YAML frontmatter (tags, parent wikilink)
- Rich markdown content (300-600 lines per file)
- Cross-references via `[[wikilinks]]` to sibling topics

## Step 4: Generate Hub File

Write hub file to `<ENTRIES_DIR>/<BookTitle>.md` with:
- Full frontmatter (tags, Category, Rating, author, Location, Chapters, Language, URL)
- Book summary
- Topic wikilinks with descriptions

## Step 5: Report

- Number of topic files generated
- Hub file path
- Topic files directory
- Suggest user review in Obsidian
