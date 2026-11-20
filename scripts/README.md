# Upstream workaround audit

`make check-patches` checks `scripts/upstream-patches.json` using authenticated
GitHub CLI requests. The Darwin and NixOS Makefile build targets run it once
before building, including `make config`. Direct `nix build` commands bypass it.
Requires `node` and `gh` on PATH. No Nix derivation performs network checks.

This is advisory: it does not block builds, update flake inputs, change pins,
remove patches, or start an agent. Network errors, missing tools, and malformed
registry entries produce warnings. Each GitHub request has a 10-second timeout.
Checks run concurrently; commit-ancestry checks can require three requests.

The output distinguishes evidence:

- `RELEASED`: the latest stable GitHub release tag contains a tracked fix commit.
  Review/update the local pin or workaround; inclusion is not permission to
  automatically delete a patch or proof that pinned nixpkgs already includes it.
- `NOT-RELEASED`: the latest release tag does not contain that commit.
- `MERGED`: a tracked PR merged, but no GitHub release was found.
- `OPEN`: a tracked PR or issue is still open.
- `REVIEW`: an issue closed, a PR closed without merging, or released source
  matches an expected fix marker. These signals do not prove the fix works.
- `NOT-FOUND`: the expected marker is absent from released source.
- `UNKNOWN` / `UNAVAILABLE`: no release or insufficient/API-failure evidence.
- `MANUAL`: intentional customization or a workaround without a verifiable
  upstream reference. No network check is attempted.

For a new temporary workaround, add its file, upstream repository, and either
`kind: "pull"` with a PR number, `kind: "commit"` with a fix SHA, or
`kind: "issue"` with an issue number. A `source` entry can check a small regex
against one file in the latest release, but only produces a review suggestion.
Use `manual` plus a reason for packaging/layout preferences or fixes that still
need a real regression check. Remove the registry entry when removing its
workaround; missing files are skipped, but entries inside shared files cannot
be automatically identified as removed.

The initial registry covers ccmux lifecycle, tmux-resurrect persistence support,
the fidget rewrite pin, the Powerline custom-message fix pin, and manual entries
for direnv, Powerline placement, and tmux-palette packaging. Other intentional
version pins/overlays are not automatically classified as temporary fixes.

Verification (no GitHub requests in the assertion check):

```sh
node scripts/check-upstream-patches.test.mjs
make check-patches
make -n HOST=work _nix_darwin_build
make -n HOST=theseus _nixos_build
```

Only the first two commands execute the checker; the last two preview builds
without building, installing requirements, using sudo, or switching systems.
