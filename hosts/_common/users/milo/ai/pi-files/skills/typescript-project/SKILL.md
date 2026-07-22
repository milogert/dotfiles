---
name: typescript-project
description: Work on TypeScript projects with minimal diffs, project-local tooling, typechecking, tests, linting, and Nix-aware dependency handling.
---

# TypeScript Project

## Workflow

1. Inspect package manager and scripts before running commands.
2. Prefer project scripts from `package.json`.
3. Use Nix/devshell if present.
4. Avoid adding dependencies without asking.
5. Prefer type-safe, minimal changes.
6. Run relevant typecheck/test/lint commands when practical.

## Notes

- Respect existing formatter/linter conventions.
- Do not rewrite large modules unless asked.
- Explain non-obvious type or architecture decisions briefly.
