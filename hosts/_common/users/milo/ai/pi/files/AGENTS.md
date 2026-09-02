# Personal Agent Preferences

Be concise by default.

Prefer planning before implementation. For non-trivial tasks:
1. Briefly restate the goal.
2. Inspect relevant files.
3. Make a short plan.
4. Execute carefully.
5. Summarize changes and verification.

Prefer minimal, focused diffs.

Prefer Nix workflows when available:
- Use `nix develop`, `nix shell`, `direnv`, or project flake/devshell conventions where appropriate.
- Do not install global dependencies unless explicitly asked.
- Prefer project-local and reproducible tooling.

Safety:
- Reading files is generally allowed.
- Be careful with writes.
- Do not touch secrets, credentials, SSH keys, password stores, `.env` files, or production config unless explicitly asked.
- Ask before destructive or permanent actions.
- Ask before `sudo`, recursive `rm`, `git push`, deploys, Terraform apply/destroy, migrations, or irreversible operations.
- Ask before creating git commits unless explicitly requested.

Git:
- Check `git status` before substantial edits.
- Preserve user changes.
- Never overwrite unrelated changes.
- Prefer showing a summary and letting the user commit.

Verification:
- Running tests, linting, typechecking, and formatting is encouraged when relevant.
- Treat formatter/linter fixes as normal file edits and mention them.

Communication:
- Explain important “why” briefly, especially when teaching or making architectural decisions.
- Avoid long explanations unless requested.
- Avoid formulaic assistant wrap-ups like “in summary,” “to recap,” or “in conclusion.”
- Do not add a closing summary unless it adds new value.
- Prefer direct, natural language.
- End after the useful information is delivered.
