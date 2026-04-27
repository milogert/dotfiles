---
name: nix-flake-init
description: Establish or improve a minimal Nix flake and dev shell for a project. Use when creating new projects, adding reproducible tooling, configuring direnv, or standardizing development commands.
---

# Nix Flake Init

Use this skill to add or improve Nix development environment support.

## Workflow

1. Inspect the project before editing:
   - language/framework
   - existing `flake.nix`, `shell.nix`, `.envrc`, `package.json`, `mix.exs`, `*.tf`, lockfiles
   - documented setup/test commands
2. Prefer the smallest useful flake.
3. Prefer reproducible project-local tooling over global installs.
4. Include `direnv` integration only when appropriate; ask before replacing an existing `.envrc`.
5. Avoid large abstractions (`flake-parts`, `devenv`, custom overlays) unless the project already uses them or the user asks.
6. Provide verification commands.

## Defaults

- Use `nixpkgs` unstable unless the repo has a pinned preference.
- Prefer `pkgs.mkShell` for simple projects.
- Add language tools needed for the project, not every possible tool.
- If adding npm/node tooling, use the Node version expected by the project when discoverable.
- If adding Elixir tooling, include appropriate `elixir`, `erlang`, and common build deps.
- For Terraform projects, include `terraform`, `tflint`, and format/check commands when useful.

## Safety

Ask before:
- deleting or replacing existing Nix files
- adding a large framework
- changing lockfiles unrelated to the Nix change
- adding binary caches or substituters
