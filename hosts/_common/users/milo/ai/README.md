# Local agent workflow

## Configuration ownership

Home Manager manages pi's settings, models, prompts, skills, and extensions, plus
Claude settings/hooks and the NixOS MCP server. Edit the Nix sources here, not
the generated symlinks in `~/.pi/agent` or `~/.claude`. No activation is implied
by a successful build; use the repository's normal host activation afterward.

Hermes is personal: its pi provider and secret declaration are omitted when
`osConfig.networking.hostName` is `work`. Personal hosts keep that provider.
The router also excludes Hermes candidates and skips decision calls while
Hermes is selected. Existing session files are not removed by this setting.

`pi-hooks` is intentionally not loaded. Peon-ping and ccmux handle notifications
and session tracking directly, without executable project hook configuration.
Claude completion and permission alerts use peon-ping, not extra bells/afplay.
The NixOS MCP server runs `pkgs.mcp-nixos` from the locked nixpkgs input rather
than resolving an unpinned GitHub flake at startup.

## Models

The router defaults to `~typesafe/jev-latest`. Override it for one launch:

```sh
PI_ROUTER_MODEL=typesafe/jev-1.13 pi
```

No shortlist is configured: other authenticated chat models remain eligible,
subject to context/image requirements. The classifier adds latency and a paid
call before each new user run; its cost is not included in the router footer.

Native scopes are inclusion patterns:

- `pi --models 'openrouter/*'` scopes a single launch.
- `/scoped-models` edits pi's runtime/saved selection.
- `enabledModels` in `pi/default.nix` sets the reproducible default.

For example, `enabledModels = [ "openrouter/*" ];` scopes startup/cycling to that
provider. Nix-managed settings can conflict with commands that save settings;
prefer CLI scopes for experiments and Nix for lasting choices. Model scopes are
not a security boundary or a reliable provider blacklist in pi 1.5.2. Hermes
is excluded explicitly by the router and omitted from the work configuration.

## Planning and parallel work

Use `/planmode execute` to accept a plan and start work, or `/planmode accept`
to approve without starting. Approval and enabled/disabled state follow the
active session branch on reload, resume, forks, and `/tree` navigation.

Use `/planmode reset` before a new task. The extension does not guess whether a
follow-up starts a different task, and approval persists until explicitly reset.
Use `/planmode off` for trivial tasks that do not need the planning guard.
Planning mode blocks `edit`/`write` before approval, but is not a shell sandbox.
For reviews without shell or write tools:

```sh
pi --tools read,grep,find,ls
```

Use `/name`, `/resume`, `/tree`, steering, and follow-ups before adding another
session plugin. `/tree` changes conversation history, not filesystem changes.
For parallel agents, give each task its own worktree. The existing `mkwt` and
`cdwt` shell helpers create/navigate those worktrees; avoid two agents editing
the same files.

## ccmux upgrade and migration

The CLI remains intentionally Homebrew-managed; the pi extension is pinned to
upstream ccmux 1.4.6 at commit `d89acbb10403c5ec944ceee701e9c5aa6b358721`.
`ccmux-path-agent-settled.nix` fixes premature idle status: retries and queued
runs remain working until pi emits `agent_settled`. Remove that patch when an
upstream release fixes the event mapping.

Before the first Home Manager activation that manages the extension, preserve
the existing installer-owned file. These are manual migration steps, not part
of a build or automatic activation hook:

```sh
mv -n ~/.pi/agent/extensions/ccmux.js ~/.pi/agent/ccmux.js.pre-nix
# Run the normal host activation, then /reload or restart pi.
ccmux daemon restart
```

Check that the move succeeded; `-n` preserves an existing backup instead of
overwriting it. Do not run `ccmux setup --agent pi` after Nix owns that file: it would conflict with the
managed extension. After CLI upgrades, restart the tracking daemon separately;
upgrading the binary does not replace an already-running daemon. Other agent
integrations remain installer-managed; use the current CLI's supported agent
names when refreshing those hooks.

## Intentional machine-local setup

These are not managed here and should be restored separately on a replacement
machine; do not copy credentials into dotfiles:

- The ccmux and peon-ping CLI installations, Claude ccmux hook scripts, and sound
  pack/category preferences. Use their installers for those resources only.
- Work-only `~/.pi/agent/mcp.json` entries, including the Swoogo server and the
  Playwright launcher under the local `www-playwright` skill. Recreate those
  entries/skill from the approved work setup, not on personal hosts by default.
- pi/Claude logins and MCP authentication. Authenticate on the new machine;
  do not version `auth.json`, `mcp-auth.json`, `.env` files, or tokens.

## Focused checks

From the repository root:

```sh
node --experimental-transform-types hosts/_common/users/milo/ai/pi/files/extensions/plan-mode-lite.test.mjs
node --experimental-strip-types hosts/_common/users/milo/ai/pi/files/extensions/model-router/index.test.mjs
ccmux_source=$(nix build --no-link --print-out-paths '.#darwinConfigurations.work.config.home-manager.users.milo.home.file."/Users/milo/.pi/agent/extensions/ccmux.js".source')
node hosts/_common/users/milo/ai/pi/files/extensions/packages/ccmux.test.mjs "$ccmux_source"
nix eval '.#darwinConfigurations.work.config.system.build.toplevel.drvPath'
nix build --no-link '.#darwinConfigurations.work.system'
```

Use matching outputs for the host being changed. Router adapter checks and
live-check limitations are documented in `pi/files/extensions/model-router/README.md`.
