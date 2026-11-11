---
name: test-saboteur
description: Sabotage implementation code to test the tests. After writing or changing tests, deliberately inject realistic bugs one at a time and verify the intended assertions catch them. Restore every mutation, strengthen tests that let bugs escape, and remove demonstrably useless tests. Use when asked to attack tests, prove regression coverage, or check whether passing tests actually protect behavior.
---

# Test Saboteur

A green test is a claim. Make it prove that claim by breaking the behavior it
supposedly protects. Attack plausible regressions, not arbitrary lines of code.

## Scope and safety

- Default to tests just written or changed in this task. Otherwise inspect the
  working tree diff, staged changes, and untracked tests. Honor explicit scope.
- Use existing project test commands and tooling, including Nix/devshells where
  available. No new mutation framework or dependencies.
- Mutate local implementation code only, never production services, secrets,
  credentials, or production config. Confirm tests use isolated resources before
  running anything with external effects; ask if that cannot be established.
- Check `git status` and record the pre-mutation contents of every touched file,
  including uncommitted work. Restore those contents, not the Git version.
  Never use `git reset`, `git checkout`, or `git restore` as cleanup.
- One mutation at a time, with no concurrent edits or test runs against mutated
  files. Record the exact edit and its inverse before applying it. Restore it
  immediately after the run, even if the command fails or times out. If interrupted,
  restore any outstanding mutation before doing more work. Verify restoration
  against the recorded contents; if concurrent changes appear, stop and ask rather
  than overwrite them. Never leave sabotage in the final diff.

## Attack loop

1. **Find the promise.** Read each scoped test and the implementation it exercises.
   Trace callers of the code you will mutate, fixtures, mocks, and assertions.
   State the observable contract and which assertion should catch a violation.
   Check that the test actually executes the real behavior rather than mocking
   it away or duplicating the implementation to compute its expected result.
2. **Get a clean baseline.** Run the narrowest command that selects the target
   test(s). Confirm they ran, were not skipped, and passed. If baseline execution
   is broken or unavailable, report the blocker; do not invent mutation evidence.
3. **Choose a small attack set.** Start with one high-value fault per distinct
   contract, usually 1–3 mutations for a new test. Prioritize the original bug
   for regression tests: temporarily reintroduce it when practical. For other
   tests, use credible failures such as:
   - Remove or invert a validation/authorization guard.
   - Change `<` to `<=`, shift a boundary, or mishandle empty input.
   - Return a wrong value, omit a field, or change ordering.
   - Skip a write/event/callback or perform it twice.
   - Swallow an error or break rollback/cleanup.
   Keep mutations syntactically valid and runnable. Do not alter tests, fixtures,
   or mocks during an attack, and do not use unconditional crashes as proof.
4. **Predict, sabotage, run, restore.** Before each edit, name the fault and
   expected failing test/assertion. Apply the smallest implementation change,
   run the selected test command, inspect the actual failure, then restore and
   verify the implementation before classifying the result:
   - **Caught:** the target test ran and failed for the intended behavioral reason.
     An assertion, or an unexpected behavior-specific exception from the test's
     exercised path, must expose the contract violation. Another test failing
     does not prove this target test works.
   - **Escaped:** the target test ran and still passed despite an observable
     violation of its contract. Investigate weak assertions, missing inputs,
     over-mocking, unawaited work, or the wrong execution path.
   - **Equivalent/out of scope:** the mutation does not violate the claimed
     contract for these inputs, or changes a different contract. It is not proof
     the test is useless; choose a better attack if needed.
   - **Inconclusive:** syntax/type/import/setup failures, no tests selected,
     skipped tests, unrelated failures, flaky outcomes, or infrastructure trouble.
     These are not caught mutations. Restore, resolve within scope, or report.
5. **Repair the defense.** With the implementation restored, strengthen escaped
   tests using the smallest meaningful input/assertion or a less mocked boundary.
   Assert observable results and required side effects, not incidental internals.
   Confirm the improved test passes on correct code, fails against the same fault
   for the right reason, and passes again after restoration. Keep test improvements,
   never mutations. Do not change the contract merely to kill a mutant. If a genuine
   implementation bug or unclear requirement appears, stop and ask before expanding
   scope.
6. **Cull only proven dead weight.** Prefer repairing a weak test. Remove a test
   only when it asserts no meaningful behavior or duplicates a retained test's
   contract, inputs, and regression detection. For duplicates, name the retained
   test and demonstrate it catches the same meaningful fault. A surviving mutation
   alone, low line coverage, or "this code is simple" is not a deletion rationale.
   Do not weaken security, error-handling, boundary, or regression coverage.
7. **Finish clean.** Verify every implementation file matches its pre-mutation
   contents. Run the final targeted tests and relevant surrounding suite when
   practical, then review the diff: only intentional test improvements/deletions
   should remain. If cleanup or verification is blocked, say exactly what remains.

## Evidence, not scores

Report briefly:

| Test | Fault injected | Outcome / failing assertion | Action |
| --- | --- | --- | --- |

Include commands run, final test results, any deletion rationale, and confirmation
that all mutations were restored. Distinguish observed outcomes from proposed or
unrun attacks. A few caught faults demonstrate specific protection, not complete
correctness; do not chase a mutation percentage or add tests just to kill mutants.
