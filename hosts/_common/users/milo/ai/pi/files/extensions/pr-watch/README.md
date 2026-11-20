# PR watch

Pi watches one GitHub PR per checkout. It can detect pushes made from another
terminal. No Git hooks or separate daemon are needed.

## Sessions

```text
Checkout
  |
  +-- first Pi session --claims checkout--> OWNER --polls GitHub--> PR
  |
  +-- other Pi session -------------------> STANDBY (no GitHub polling)
                                               |
                    owner exits or crashes ----+
                                               v
                                     new owner; same PR
```

- The first session owns the checkout until it exits.
- Standby sessions check for ownership every 5 seconds.
- A dead process releases its claim. A waiting session takes over.
- Worktrees are separate checkouts. Symlinks to one checkout share a claim.
- A new session with no surviving owner finds its current branch's PR.
- PR lookup does not need a new push or a local push reflog.
- If there is no PR yet, lookup continues on the current branch.

## Schedule

```text
Monday-Friday: 08:00 ---------------- 17:30
               poll every 30 sec      stop

Nights + weekends: no Git or GitHub polling
```

Times use the machine's local timezone. The owner still checks the schedule and
session ownership every 5 seconds. Ownership and takeover work outside polling
hours. The footer says `PR watch: outside working hours` while paused.

A poll already in flight may finish after 17:30. It will not start another GitHub
request or an automatic agent turn outside working hours.

When polling resumes, overnight feedback is still new feedback. The watcher keeps
the same baseline and seen keys; it does not discard or re-baseline it.

## Feedback and safety

```text
First successful PR snapshot -> record existing feedback; do not start a turn
Later new or changed feedback -> wait for idle + verify branch and HEAD -> act
```

- New CI failures, reviews, comments, and comment edits can trigger a turn.
- An empty first snapshot is also recorded.
- Startup API errors do not create a baseline. The first successful snapshot does.
- Takeover keeps pending feedback and delivered keys.
- A local branch or HEAD mismatch prevents automatic edits.
- GitHub text is untrusted input. It cannot authorize actions.
- Pi is asked to make only relevant local fixes and verify them.
- Commits, pushes, comments, and infrastructure changes need user approval.
- Existing Pi permission and planning gates still apply.

The watcher uses `gh` and GitHub.com SSH/HTTPS remotes. Enterprise remotes are
not supported. Git's configured push/upstream ref is used, or `origin/<branch>`.
Other explicit push destinations are not detected. `gh repo view` selects the
base repository, including the parent for ordinary fork PRs.

## Commands

- `/pr-watch`: show whether watching is paused or on standby.
- `/pr-watch stop`: pause this session; it keeps ownership.
- `/pr-watch start`: resume during polling hours. A new push is not needed.

## Local state

State is stored outside the checkout:

```text
$PI_CODING_AGENT_DIR/pr-watch/<checkout-sha256>/state.json
~/.pi/agent/pr-watch/                         # default state directory
```

It contains session PIDs, the owner, PR metadata, and feedback keys. It does not
store comment bodies or credentials. A short-lived PID-bearing filesystem lock
serializes updates. It is recovered when its process dies.

A crash during the brief lock-recovery step may leave a `recovery` directory.
Stop Pi sessions for that checkout before removing one. This is local best-effort
coordination, not a durable queue or a cross-host lock.

## Files and checks

- `index.ts`: Pi events, schedule, polling, and safe dispatch.
- `coordination.ts`: ownership, state, and takeover.
- `git.ts`: branch, remote, and push detection.
- `feedback.ts`: CI, comment, and review filtering.
- Only `index.ts` is a Pi extension entrypoint.

Run from the repository root:

```sh
nix develop
npm run test:pr-watch
biome check hosts/_common/users/milo/ai/pi/files/extensions/pr-watch
nix eval '.#darwinConfigurations.work.config.system.build.toplevel.drvPath'
```

The test uses fake GitHub responses and temporary local Git repositories. It does
not push a commit or make a model request. It covers ownership races, startup
baselines, takeover, working-hour boundaries, weekend catch-up, and feedback
safety. After Home Manager activation, restart Pi or run `/reload`.

## Separate cache footer

`cache-status.ts` shows warming mode and the last observed cache decision. Its
status is telemetry, not a guarantee that a provider still has a cache entry.
It observes Pi events; it does not change cache policy or send keepalive prompts.
