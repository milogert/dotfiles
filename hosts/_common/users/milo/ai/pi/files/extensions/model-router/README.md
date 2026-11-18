# Model router

Automatically asks TypeSafe's Jev decision model to select a work model before
pi starts each new request. The original prompt and full work conversation are
unchanged. Queued steering/follow-up messages continue on the active model;
the router never switches between tool calls.

## Setup

The recursive Home Manager mapping installs `index.ts` globally on normal
configuration activation. Reload or restart pi afterward. For an isolated test
without activation, use `--no-extensions` with `-e` (this also disables other
extensions, so do not use it as your normal safety setup):

```sh
pi --no-extensions -e ~/.dotfiles/hosts/_common/users/milo/ai/pi/files/extensions/model-router/index.ts
```

Do not explicitly load a second router on top of the auto-discovered one.

Requires pi 1.5.2 or newer. Authenticate using `/login openrouter`. The extension
uses pi's classifier catalog and `ctx.modelRegistry.classify()` for authentication,
provider configuration, request serialization, and response validation; it does
not read credential files itself.

Use `/scoped-models` or `pi --models 'provider/model,...'` to restrict candidates.
Without a scope, all authenticated models except the personal `hermes` provider
are candidates. Hermes is not configured at all on the `work` host. On personal
hosts it remains manually selectable; selecting it bypasses Jev routing entirely.
Models with insufficient context space or without required image support are
excluded.
Scoped thinking levels are honored; otherwise pi preserves/clamps the existing
thinking level. Jev selects the model, not its thinking level.

- `/router off` disables routing for this extension instance (use before manually selecting a model).
- `/router on` enables it again.
- `/router status` shows whether it is enabled; routing defaults to on after reload/new session.
- `PI_ROUTER_MODEL=<classifier-model-id> pi ...` overrides the default
  `~typesafe/jev-latest`; use `typesafe/jev-1.13` to pin the decision model.
  The latest alias can move to new releases; workspace guardrails must allow
  whichever release it resolves to.

`typesafe/jev-router` is OpenRouter's chat-completion router, not the classifier
used here. Choice descriptions are strings containing candidate metadata, as
required by System One. Custom-message runs do not trigger routing.

Routing sends the new prompt, up to four recent user/assistant messages bounded
to 4,000 characters, and candidate model metadata through pi's configured
OpenRouter classifier provider (System One by default).
It does **not** add tool outputs, thinking blocks, system instructions, image
bytes, or repository file reads. Prompts and dialogue can still contain sensitive
information; use `/router off` when they must not be shared with Jev. The work
model still receives the full normal pi context.

Each routed request adds one paid decision call when at least two candidates
are available. Selection has a ten-second timeout; authentication/API errors and
invalid choices warn in interactive mode and continue with the current model.
A model change made manually while Jev is pending takes precedence. Pi's
`setModel()` changes the session, not the default model for new sessions.
Routing costs are billed by OpenRouter but are not included in pi's agent-token
footer totals.

## Verification

No network or credentials are used by the checks:

```sh
node --experimental-strip-types index.test.mjs
```

To also exercise the installed pi classifier catalog, authentication resolution,
and HTTP adapter with a fake key and mocked HTTP, point at pi's SDK entry point
(`dist/bundle/index.js` for the Nix package, `dist/index.js` for an npm install):

```sh
PI_ROUTER_TEST_SDK=/absolute/path/to/pi/dist/bundle/index.js \
  node --experimental-strip-types index.test.mjs
```

Offline extension-loading smoke check (no model request):

```sh
pi --offline --no-session --no-extensions -e ./index.ts --help
```

Live synthetic routing checks with `typesafe/jev-1.13` and `~typesafe/jev-latest`
succeeded through the configured OpenRouter account. Both selected GPT-4o mini from two supplied
candidates. Offline checks still do not establish future provider availability
or end-to-end routing in an activated interactive session.

API reference: https://openrouter.ai/docs/guides/community/typesafe-sdk
