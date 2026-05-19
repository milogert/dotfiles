---
name: elixir-project
description: Work on Elixir or Phoenix projects with project conventions, Mix tasks, tests, formatting, supervision, Ecto, and Nix/devshell awareness.
---

# Elixir Project

## Workflow

1. Inspect `mix.exs`, config, and existing tests.
2. Use project Mix aliases/tasks where available.
3. Prefer Nix/devshell if present.
4. Run focused tests first, then broader tests when practical.
5. Respect OTP supervision and existing context boundaries.
6. Ask before database migrations or irreversible data changes.

## Commands

Common verification commands, if applicable:

```bash
mix format --check-formatted
mix test
mix credo
```

Use only commands that exist or are appropriate for the project.
