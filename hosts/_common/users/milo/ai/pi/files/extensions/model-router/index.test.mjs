import assert from "node:assert/strict";
import router from "./index.ts";

const model = (id, extra = {}) => ({ provider: "test", id, name: id, input: ["text", "image"], reasoning: true, contextWindow: 128000, maxTokens: 4096, cost: { input: 1, output: 2 }, ...extra });
const a = model("cheap"), b = model("strong"), textOnly = model("text", { input: ["text"] });

async function run({ answer = "test/strong", http = 200, failure, auth = true, scoped, images, usage, branch = [], during, switchOK = true } = {}) {
  const handlers = {}, commands = {}, switched = [], thinking = [], notices = [], statuses = [], requests = [];
  const ctx = {
    hasUI: true, model: a, scopedModels: scoped ?? [{ model: a }, { model: b, thinkingLevel: "high" }],
    modelRegistry: { getAvailable: () => [a, b, textOnly], getProviderAuth: async () => auth ? { auth: { apiKey: "mock-key" } } : undefined },
    sessionManager: { getBranch: () => branch }, getContextUsage: () => usage,
    ui: { notify: (...args) => notices.push(args), setStatus: (...args) => statuses.push(args) },
  };
  router({
    on: (name, fn) => handlers[name] = fn,
    registerCommand: (name, command) => commands[name] = command,
    setModel: async (selected) => { if (switchOK) { switched.push(selected); ctx.model = selected; } return switchOK; },
    setThinkingLevel: (level) => thinking.push(level),
  });
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (url, options) => {
    requests.push({ url, ...options, body: JSON.parse(options.body) });
    await during?.(commands.router, ctx);
    if (failure) throw new Error(failure);
    return { ok: http === 200, status: http, json: async () => ({ answers: { model: { type: "choice", choice: answer } } }) };
  };
  const event = { prompt: "Fix the parser", images };
  try {
    await handlers.before_agent_start(event, ctx);
  } finally {
    globalThis.fetch = originalFetch;
  }
  assert.equal(event.prompt, "Fix the parser");
  assert.deepEqual(Object.keys(handlers), ["before_agent_start"]);
  if (statuses.length) assert.deepEqual(statuses.at(-1), ["model-router", undefined]);
  return { switched, thinking, notices, requests, commands, ctx };
}

const result = await run({ branch: [
  { type: "message", message: { role: "user", content: "x".repeat(5000) } },
  { type: "message", message: { role: "toolResult", content: [{ type: "text", text: "DO NOT SEND TOOL OUTPUT" }] } },
  { type: "message", message: { role: "assistant", content: [{ type: "text", text: "Investigating" }, { type: "thinking", thinking: "DO NOT SEND THINKING" }] } },
] });
assert.deepEqual(result.switched, [b]);
assert.deepEqual(result.thinking, ["high"]);
assert.equal(result.requests[0].url, "https://openrouter.ai/api/v1/systemone");
assert.equal(result.requests[0].headers.Authorization, "Bearer mock-key");
assert.equal(result.requests[0].body.model, process.env.PI_ROUTER_MODEL || "typesafe/jev-router");
assert.deepEqual(Object.keys(result.requests[0].body.questions.model.criteria), ["test/cheap", "test/strong"]);
assert.equal(result.requests[0].body.state.recentConversation.length, 4000);
assert.ok(!JSON.stringify(result.requests[0].body).includes("DO NOT SEND"));
assert.equal(result.requests[0].body.state.request, "Fix the parser");
assert.ok(result.requests[0].signal instanceof AbortSignal);

for (const options of [{ answer: "invented/model" }, { http: 429 }, { failure: "timeout" }, { auth: false }, { switchOK: false }]) {
  const failed = await run(options);
  assert.deepEqual(failed.switched, []);
  assert.equal(failed.ctx.model, a);
  assert.equal(failed.notices.at(-1)[1], "warning");
}
assert.deepEqual((await run({ answer: "test/cheap" })).switched, []);
assert.deepEqual((await run({ scoped: [{ model: a }] })).requests, []);
assert.deepEqual((await run({ usage: { tokens: 125000 } })).requests, []);
assert.deepEqual((await run({ usage: { tokens: null }, branch: [{ type: "message", message: { role: "bashExecution", command: "ls" } }] })).switched, [b]);
const vision = await run({ scoped: [], images: [{ type: "image" }] });
assert.deepEqual(Object.keys(vision.requests[0].body.questions.model.criteria), ["test/cheap", "test/strong"]);
assert.equal(vision.requests[0].body.state.hasImages, true);
const historicalImage = await run({ scoped: [], branch: [{ type: "message", message: { role: "user", content: [{ type: "image" }] } }] });
assert.ok(!("test/text" in historicalImage.requests[0].body.questions.model.criteria));
assert.deepEqual((await run({ during: (command, ctx) => command.handler("off", ctx) })).switched, []);
assert.deepEqual((await run({ during: (_command, ctx) => { ctx.model = textOnly; } })).switched, []);
await result.commands.router.handler("off", result.ctx);
assert.match(result.notices.at(-1)[0], /router off/);
await result.commands.router.handler("on", result.ctx);
assert.match(result.notices.at(-1)[0], /router on/);
await result.commands.router.handler("status", result.ctx);
assert.match(result.notices.at(-1)[0], /router on/);
console.log("Model router checks passed");
