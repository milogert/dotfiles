---
description: Add or improve a Nix flake for this project
argument-hint: "[language/framework]"
---
Help establish a Nix flake/devshell for this project.

Project type or hints:
$ARGUMENTS

Inspect the repository first. Prefer a minimal flake that provides:
- reproducible dev shell
- language/package-manager tooling
- formatter/linter/test commands where obvious
- direnv compatibility if appropriate

Ask before adding large abstractions.
