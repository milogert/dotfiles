# Model router

Automatically asks TypeSafe's Jev decision model to select a work model before
pi starts each new request. The original prompt and full work conversation are
unchanged. Queued steering/follow-up messages continue on the active model;
the router never switches between tool calls.

## Setup

The existing recursive Home Manager mapping installs `index.ts` globally on the
next normal configuration activation. Until then, test without activation:

```sh
pi -e ~/.dotfiles/hosts/_common/users/milo/ai/pi/files/extensions/model-router/index.ts
```

Authenticate using `/login openrouter`. The extension resolves authentication
through pi; it does not read credential files itself.

Use `/scoped-models` or `pi --models 'provider/model,...'` to restrict candidates.
Without a scope, all authenticated models in pi's catalog are candidates. Models
with insufficient context space or without required image support are excluded.
Scoped thinking levels are honored; otherwise pi preserves/clamps the existing
thinking level. Jev selects the model, not its thinking level.

- `/router off` disables routing for this extension instance (use before manually selecting a model).
- `/router on` enables it again.
- `/router status` shows whether it is enabled; routing defaults to on after reload/new session.
- `PI_ROUTER_MODEL=<model-id> pi ...` overrides the default `typesafe/jev-router`.

This default is experimental: OpenRouter documents `typesafe/jev-router` for
completion routing, not the System One decision endpoint used here. Live
compatibility is unverified; a rejected request keeps the current work model.

Routing sends the new prompt, up to four recent user/assistant messages bounded
to 4,000 characters, and candidate model metadata to OpenRouter's System One API.
It does **not** add tool outputs, thinking blocks, system instructions, image
bytes, or repository file reads. Prompts and dialogue can still contain sensitive
information; use `/router off` when they must not be shared with Jev. The work
model still receives the full normal pi context.

Each routed request adds one paid decision call. Selection has a ten-second HTTP
timeout; authentication/API errors and invalid choices warn and continue with the
current model. A model change made manually while Jev is pending takes precedence.
Pi's normal `setModel()` also updates its default model setting. Routing costs
are billed by OpenRouter but are not included in pi's agent-token footer totals.

## Verification

No network or credentials are used by the checks:

```sh
node --experimental-strip-types index.test.mjs
```

API reference: https://openrouter.ai/docs/guides/community/typesafe-sdk
