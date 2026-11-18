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
- Use risk-based verification, not the full suite by default. Run the smallest meaningful checks covering the changed behavior and affected callers.
- Use the project's documented commands and development environment. For code or build changes, inspect relevant CI configuration so local checks use compatible flags, versions, and setup.
- For bug fixes, add or update a focused regression test when practical. Confirm it fails with the bug present and passes with the fix.
- Run relevant formatting, linting, and typechecking checks. Scope them to changed files or packages where supported; avoid unrelated expensive checks.
- Broaden verification for shared code, public interfaces, dependencies, build/CI configuration, or changes spanning multiple components. Run the full suite when these changes have broad or unclear impact, when explicitly requested, or when the project requires it.
- After the final edit, rerun checks affected by that edit. Unrelated passing checks remain valid; do not restart everything automatically.
- Fix failures caused by your changes. Never skip, disable, or weaken tests just to obtain a passing result.
- Report commands run, results, and important checks not run. Distinguish "focused checks passed" from "full CI passed"; do not imply broader coverage than was verified.
- If verification is blocked or disproportionately expensive, report the limitation and remaining risk rather than repeatedly retrying or silently claiming success. Ask before proceeding when the unverified risk is material.
- Documentation-only changes need review and applicable formatting/link checks, not unrelated application tests.

Communication:
- Use only ASCII quotation marks: " (U+0022) and ' (U+0027).
- Never use curly/smart quotes or Unicode quotation marks, including in contractions and generated files.
- Explain important “why” briefly, especially when teaching or making architectural decisions.
- Avoid long explanations unless requested.
- Avoid formulaic assistant wrap-ups like “in summary,” “to recap,” or “in conclusion.”
- Do not add a closing summary unless it adds new value.
- Prefer direct, natural language.
- End after the useful information is delivered.

Global Coding Standards
1. YAGNI: Don't build it until you need it
2. DRY: Extract patterns after second duplication, not before.
3. Fail Fast: Explicit errors beat silent failure
4. Simple First: Write the obvious solution, optimize only if needed
5. Delete Aggressively: Less code = fewer bugs
6. Semantic naming: Always name variables, parameters, and API endpoints with verbose, self-documenting names that optimize for comprehension by both human and LLMs, not brevity.
7. Follow Established Patterns: Always prefer using an established codebase pattern before using a novel one.
