---
name: de-yap
description: Strip AI-generated filler from code and prose — comments that restate the line below them, defensive explanations of obvious choices, ceremonial docstrings, and summary blocks nobody asked for. Use when the user says "de-yap", "deyap", "strip the comments", "remove the AI slop", "too many comments", "clean up the noise", or when reviewing/committing code that an AI just wrote.
---

# De-yap

AI writes comments for its own benefit: to think out loud, to prove it did the
work, to hedge. None of that is for the reader. Delete it.

Default scope: the working tree diff (`git diff` + `git diff --cached`, plus
untracked files). If the user names files or a range, use that instead.

## What to delete

**Restatement.** The comment says what the next line says.

```php
// Get the user
$user = User::findOne($id);

// Loop through the results
foreach ($results as $result) {
```

**Section headers in short functions.** `// Validate input`, `// Build the
query`, `// Return the response` over a 20-line function. If the function needs
signposting it needs splitting.

**Self-narration.** Comments addressed to nobody, or to the reviewer.

```js
// Note: we use a Map here for O(1) lookups
// This handles the edge case where the array is empty
// Now we can safely proceed
```

**Defensive justification.** Explaining an obvious or conventional choice as if
challenged. If the choice is genuinely non-obvious, keep one line saying *why* —
delete the paragraph around it.

**Ceremonial docblocks.** PHPDoc/JSDoc that only echoes the signature and adds
no type info the language doesn't already carry.

```php
/**
 * Sets the name.
 *
 * @param string $name The name
 * @return void
 */
public function setName(string $name): void
```

Keep the docblock when it adds something: `@throws`, an array shape
(`@return array<int, User>`), a `@deprecated`, a non-obvious contract.

**Changelog comments.** `// Added in PR #123`, `// Changed 2026-01-04`,
`// Removed the old implementation`. Git knows.

**Dead code kept "for reference."** Commented-out blocks. Git knows.

**Emoji headers and decoration.** `// ===== SECTION =====`, `// 🚀 Setup`.

**Prose padding** (in docs, PR bodies, commit messages, READMEs):
- Openers that restate the title: "This PR introduces changes that…"
- Closers that summarize what was just read: "In summary…", "Overall, this…"
- Triads of adjectives: "robust, scalable, and maintainable"
- "It's worth noting that", "It's important to understand", "Simply", "Just",
  "Essentially", "Basically"
- Bold-lead bullets where the bold text is the only content
- Tables with two rows and one real column

## What to keep

Never strip:

- **Why, not what.** Business rules, workarounds, bug references, "the vendor
  API returns 200 on failure", `ponytail:` markers with a named ceiling.
- **Non-obvious constraints.** Ordering requirements, locking, race windows,
  perf reasoning backed by an actual number.
- Legal headers, license blocks, `@license`, copyright.
- Linter/tooling directives: `// eslint-disable-next-line`, `/** @var */` type
  hints the IDE needs, `# type: ignore`, `@phpstan-*`, `@psalm-*`, `@codeCoverageIgnore`.
- `TODO` / `FIXME` / `HACK` with real content.
- Doc comments that are the public API surface of a library.
- Anything the user wrote themselves. Check `git blame` if unsure who authored a
  comment in a file you're editing; only strip lines from the current change.

Rule of thumb: **delete the comment, read the code. Still understand it? The
comment was yap.**

## Steps

1. Get scope — diff by default, or the files the user named.
2. Read each changed file fully. Comments only make sense in context; a line
   that reads as restatement in a diff hunk may be documenting a real gotcha two
   functions up.
3. Delete per the rules above. Edit in place; no rewrites of the surrounding
   code — this pass touches comments and prose only.
4. When a comment is borderline, ask: does this survive the delete-and-reread
   test? If it does, keep it. Bias to keeping *why*, deleting *what*.
5. Report: one line per file, count of lines cut. Then the borderline calls you
   made, if any. No essay.

Do not change behavior. If you spot a real bug while reading, mention it after
the report — don't fix it in this pass.

## Report format

```
modules/foo/Bar.php        -12
assets/js/baz.js            -7
README.md                   -4 (prose)

Kept: Bar.php:88 — "vendor returns 200 on failure" (why, not what)
```
