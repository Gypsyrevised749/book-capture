# Contributing to Book Capture

Thank you for your interest in contributing to the Book Capture plugin!

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/book-capture.git
   ```
3. Test your changes locally:
   ```bash
   claude --plugin-dir ./book-capture
   ```

## Development

### Plugin Structure

- `commands/` — Slash commands (`.md` files with YAML frontmatter)
- `agents/` — Subagent definitions for parallel OCR and content generation
- `skills/` — Auto-activating skill that routes to commands
- `scripts/` — Node.js scripts for capture, OCR, and markdown generation

### Testing Changes

1. Edit files in the plugin directory
2. Start a new Claude Code session with `--plugin-dir`:
   ```bash
   claude --plugin-dir ./book-capture
   ```
3. Test commands: `/book-capture:kindle`, `/book-capture:books`, etc.

### Validating

```bash
claude plugin validate ./
```

### Code Style

- Scripts use ESM (`import`/`export`) with `.mjs` extension
- YAML frontmatter values must be quoted if they contain special characters
- Use `${CLAUDE_PLUGIN_ROOT}` for all intra-plugin path references in commands

## Submitting Changes

1. Create a feature branch: `git checkout -b feature/my-change`
2. Make your changes
3. Run `claude plugin validate ./` to verify
4. Commit with a descriptive message
5. Push and open a Pull Request

## Ideas for Contributions

- Support for additional platforms (e.g., Google Play Books, Kobo)
- Improved OCR for complex layouts (tables, diagrams, equations)
- Language-specific OCR tuning
- Better duplicate page detection algorithms
- Windows/Linux support for screenshot capture

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
