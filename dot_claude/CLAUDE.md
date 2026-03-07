# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code).

## Git Commit Convention
- **Format**: ` <subject>`
- **Subject Rules**:
  - Max 50 characters
  - Imperative mood ("add" not "added")
  - No period at the end
- **Commit Structure**:
  - Simple changes: One-line commit only
  - Complex changes: Add body (72-char lines) explaining what/why
- **Best Practices**:
  - Keep commits atomic (one logical change)
  - Make them self-explanatory
  - Split different concerns into separate commits

## Tool Preferences
- **Search**: `rg` instead of `grep`
- **Find**: `fd` instead of `find`
- **Visualizations**: `tree`
- **Task Runner**: `Taskfile` instead of `make`
- **Documentation**: Context7 MCP for library documentation, code generation, setup or configuration steps

## Code Style
- **Naming**: Variable and function names should generally be complete words.
- **Comments**: Prefer self-documenting code over excessive comments. Only comment when something is surprising, unclear, or not following typical patterns. Use complete sentences and end them with a period. Provide links where appropriate.

## Code Quality

### Testing And Validation
- Run existing tests after changes; fix anything you break
- Add tests for new functionality when a test framework is present
- Verify type checking and linting pass if configured in the project
- For API changes, verify request/response contracts

## Language Specific Preferences

### Python Preferences
- **Dependency Management**: Always use `uv` to manage dependencies
- **Type Hinting**: Always use type hints when writing or refactoring code
- **Type Checking**: Always Use `ty` strict rules
- **Formatting** Always use `ruff` formatting
