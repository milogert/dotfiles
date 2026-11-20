import assert from "node:assert/strict";
import { mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

assert.ok(
  process.argv[2] && process.argv[3],
  "Pass footer index.ts and the installed Pi package directory",
);
const directory = mkdtempSync(join(tmpdir(), "powerline-custom-message-"));
const previousAgentDirectory = process.env.PI_CODING_AGENT_DIR;
const previousKey = process.env.TYPESAFE_API_KEY;
const previousFetch = globalThis.fetch;
const requests = [];

try {
  process.env.PI_CODING_AGENT_DIR = directory;
  process.env.TYPESAFE_API_KEY = "test-only-no-network";
  writeFileSync(
    join(directory, "settings.json"),
    JSON.stringify({ powerline: { welcome: false, autoFollowUp: true } }),
  );
  globalThis.fetch = async (_url, options) => {
    requests.push(JSON.parse(options.body));
    return Response.json({ answers: { route: { choice: "follow_up", confidence: 0.95 } } });
  };

  const { loadExtensions, createExtensionRuntime } = await import(
    pathToFileURL(join(process.argv[3], "dist/core/extensions/loader.js"))
  );
  const runtime = createExtensionRuntime();
  runtime.getCommands = () => [];
  runtime.sendUserMessage = () => {};
  const loaded = await loadExtensions([process.argv[2]], directory, undefined, runtime);
  assert.deepEqual(loaded.errors, []);
  const handlers = loaded.extensions[0].handlers;
  const ctx = {
    cwd: directory,
    hasUI: false,
    isIdle: () => false,
    signal: new AbortController().signal,
    sessionManager: { getBranch: () => [] },
    ui: { notify() {}, setWorkingMessage() {} },
  };
  const emit = async (name, event) => {
    for (const handler of handlers.get(name) ?? []) await handler(event, ctx);
  };
  const currentTask = async () => {
    await emit("input", { text: "also lint", source: "interactive", streamingBehavior: "steer" });
    return requests.at(-1).state.current_task;
  };

  await emit("before_agent_start", { messageType: "user", prompt: "Fix the checkout bug" });
  await emit("before_agent_start", {
    messageType: "custom",
    message: { role: "custom", customType: "pr-feedback", content: "CI failed", display: true },
  });
  assert.equal(
    await currentTask(),
    "Fix the checkout bug",
    "PR feedback must not crash or replace the last user task",
  );
  await emit("before_agent_start", { messageType: "user", prompt: "Fix the login bug" });
  assert.equal(
    await currentTask(),
    "Fix the login bug",
    "Normal user runs must still update the task",
  );
  await emit("before_agent_start", { prompt: "Fix the search bug" });
  assert.equal(
    await currentTask(),
    "Fix the search bug",
    "Older Pi events without messageType must remain supported",
  );
} finally {
  globalThis.fetch = previousFetch;
  if (previousAgentDirectory === undefined) delete process.env.PI_CODING_AGENT_DIR;
  else process.env.PI_CODING_AGENT_DIR = previousAgentDirectory;
  if (previousKey === undefined) delete process.env.TYPESAFE_API_KEY;
  else process.env.TYPESAFE_API_KEY = previousKey;
}
console.log(
  "Powerline custom-message and user-prompt regression check passed (no network requests)",
);
