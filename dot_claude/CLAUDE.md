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
- **Comments**: Prefer self-documenting code over excessive comments. Only comment when something is surprising, unclear, or not following typical patterns.

## Code Quality

- **Testing**: Add tests for new functionality
- **Validation**: Run existing tests after changes; fix anything you break
- **Types**: Use type hints or explicit types
- **Bug Fixes**: Always address root cause, not symptoms
