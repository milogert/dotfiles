import assert from "node:assert/strict";
import router from "./index.ts";

const model = (id, extra = {}) => ({ provider: "test", id, name: id, input: ["text", "image"], reasoning: true, contextWindow: 128000, maxTokens: 4096, cost: { input: 1, output: 2 }, ...extra });
const a = model("cheap"), b = model("strong"), textOnly = model("text", { input: ["text"] });
const hermes = model("hermes", { provider: "hermes" });
const decisionModel = { provider: "openrouter", id: process.env.PI_ROUTER_MODEL || "~typesafe/jev-latest" };

async function run({
  answer = "test/strong",
  failure,
  stopReason = "stop",
  classifier = true,
  scoped,
  images,
  usage = { tokens: 1000 },
  branch = [],
  entries = branch,
  during,
  duringConfirmation,
  choice = "Switch once",
  switchOK = true,
  messageType = "user",
  signal,
  hasUI = true,
  registry,
  currentModel = a,
  destinationModel = b,
  prompt = "Fix the parser",
} = {}) {
  const handlers = {},
    commands = {},
    switched = [],
    thinking = [],
    notices = [],
    statuses = [],
    requests = [],
    confirmations = [];
  const ctx = {
    hasUI,
    signal,
    model: currentModel,
    scopedModels: scoped ?? [{ model: a }, { model: destinationModel, thinkingLevel: "high" }],
    modelRegistry: {
      getAvailable: () => [a, destinationModel, textOnly, hermes],
      findOfType: (type, provider, id) => {
        assert.deepEqual([type, provider, id], ["classifier", "openrouter", decisionModel.id]);
        return classifier ? (registry?.findOfType(type, provider, id) ?? decisionModel) : undefined;
      },
      classify: async (selectedClassifier, context, options) => {
        requests.push({ classifier: selectedClassifier, body: context, signal: options.signal });
        await during?.(commands.router, ctx);
        if (registry) return registry.classify(selectedClassifier, context, options);
        return {
          stopReason,
          errorMessage: failure,
          answers: { model: { type: "choice", choice: answer } },
        };
      },
    },
    sessionManager: { getBranch: () => branch, getEntries: () => entries },
    getContextUsage: () => usage,
    ui: {
      notify: (...args) => notices.push(args),
      setStatus: (...args) => statuses.push(args),
      select: async (...args) => {
        confirmations.push(args);
        await duringConfirmation?.(commands.router, ctx);
        return choice ?? undefined;
      },
    },
  };
  router({
    on: (name, fn) => (handlers[name] = fn),
    registerCommand: (name, command) => (commands[name] = command),
    setModel: async (selected) => {
      if (switchOK) {
        switched.push(selected);
        ctx.model = selected;
      }
      return switchOK;
    },
    setThinkingLevel: (level) => thinking.push(level),
  });
  const event =
    messageType === "user"
      ? { messageType, prompt, images }
      : { messageType, message: { content: "Continue" } };
  const trigger = () => handlers.before_agent_start(event, ctx);
  await trigger();
  if (messageType === "user") assert.equal(event.prompt, prompt);
  assert.deepEqual(Object.keys(handlers), ["before_agent_start"]);
  if (statuses.length) assert.deepEqual(statuses.at(-1), ["model-router", undefined]);
  return { switched, thinking, notices, requests, confirmations, commands, ctx, trigger };
}

const result = await run({ branch: [
  { type: "message", message: { role: "user", content: "x".repeat(5000) } },
  { type: "message", message: { role: "toolResult", content: [{ type: "text", text: "DO NOT SEND TOOL OUTPUT" }] } },
  { type: "message", message: { role: "assistant", content: [{ type: "text", text: "Investigating" }, { type: "thinking", thinking: "DO NOT SEND THINKING" }] } },
] });
assert.deepEqual(result.switched, [b]);
assert.deepEqual(result.thinking, ["high"]);
assert.deepEqual(result.requests[0].classifier, decisionModel);
assert.deepEqual(Object.keys(result.requests[0].body.questions.model.criteria), ["test/cheap", "test/strong"]);
for (const description of Object.values(result.requests[0].body.questions.model.criteria)) {
  assert.equal(typeof description, "string", "System One choice criteria must be strings");
  assert.equal(JSON.parse(description).contextWindow, 128000);
}
assert.equal(result.requests[0].body.state.recentConversation.length, 4000);
assert.ok(!JSON.stringify(result.requests[0].body).includes("DO NOT SEND"));
assert.equal(result.requests[0].body.state.request, "Fix the parser");
assert.ok(result.requests[0].signal instanceof AbortSignal);

for (const options of [{ answer: "invented/model" }, { stopReason: "error", failure: "HTTP 429" }, { stopReason: "aborted", failure: "timeout" }, { stopReason: "error", failure: "No API key" }, { classifier: false }, { switchOK: false }]) {
  const failed = await run(options);
  assert.deepEqual(failed.switched, []);
  assert.equal(failed.ctx.model, a);
  assert.equal(failed.notices.at(-1)[1], "warning");
}
assert.deepEqual((await run({ answer: "test/cheap" })).switched, []);
assert.deepEqual((await run({ messageType: "custom" })).requests, []);
assert.deepEqual((await run({ hasUI: false })).switched, [b]);
const personal = await run({ currentModel: hermes });
assert.deepEqual(personal.requests, [], "Personal Hermes prompts must not reach Jev");
assert.deepEqual(personal.switched, []);
const withHermesScoped = await run({ scoped: [{ model: a }, { model: b }, { model: hermes }] });
assert.deepEqual(Object.keys(withHermesScoped.requests[0].body.questions.model.criteria), ["test/cheap", "test/strong"]);
assert.deepEqual((await run({ answer: "hermes/hermes" })).switched, []);
const aborted = new AbortController();
aborted.abort();
const cancelled = await run({ signal: aborted.signal });
assert.equal(cancelled.requests[0].signal.aborted, true);
assert.deepEqual(cancelled.switched, []);
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
// A fixed clock makes the three-minute boundary deterministic without sleeps.
const originalNow = Date.now;
const originalCostLimit = process.env.PI_ROUTER_COST_LIMIT_USD;
Date.now = () => 1_800_000_000_000;
delete process.env.PI_ROUTER_COST_LIMIT_USD;
try {
  const expensiveModel = model("strong", { cost: { input: 10, output: 20 } });
  const costlyRequest = { destinationModel: expensiveModel, usage: { tokens: 100000 } };
  const successfulUse = (age, extra = {}) => ({
    type: "message",
    timestamp: new Date(Date.now() - age).toISOString(),
    message: {
      role: "assistant",
      provider: expensiveModel.provider,
      model: expensiveModel.id,
      stopReason: "stop",
      ...extra,
    },
  });

  const cold = await run(costlyRequest);
  assert.equal(cold.confirmations.length, 1, "An expensive first use must ask for approval");
  assert.match(cold.confirmations[0][0], /test\/strong.*\$1\.00/);
  assert.deepEqual(cold.confirmations[0][1], [
    "Stay on current model",
    "Switch once",
    "Stay and disable routing for this session",
  ]);
  assert.deepEqual(cold.switched, [expensiveModel]);
  assert.deepEqual(cold.thinking, ["high"]);
  cold.ctx.model = a;
  await cold.trigger();
  assert.equal(cold.confirmations.length, 2, "Selecting a model without a reply must not warm it");

  for (const choice of ["Stay on current model", null, "unexpected"]) {
    const stayed = await run({ ...costlyRequest, choice });
    assert.deepEqual(stayed.switched, []);
    assert.deepEqual(stayed.thinking, []);
    assert.equal(stayed.ctx.model, a);
    await stayed.trigger();
    assert.equal(stayed.requests.length, 2, "Staying once must not disable routing");
  }
  const disabled = await run({
    ...costlyRequest,
    choice: "Stay and disable routing for this session",
  });
  assert.deepEqual(disabled.switched, []);
  await disabled.trigger();
  assert.equal(disabled.requests.length, 1, "Session opt-out must skip later Jev calls");
  await disabled.commands.router.handler("on", disabled.ctx);
  await disabled.trigger();
  assert.equal(disabled.requests.length, 2, "/router on must re-enable routing");
  assert.equal(
    (await run(costlyRequest)).confirmations.length,
    1,
    "A new session must not inherit opt-out",
  );

  const warm = await run({ ...costlyRequest, entries: [successfulUse(179999)] });
  assert.deepEqual(warm.confirmations, []);
  assert.deepEqual(
    warm.switched,
    [expensiveModel],
    "A recent successful use may switch without confirmation",
  );
  const latest = await run({
    ...costlyRequest,
    entries: [successfulUse(240000), successfulUse(1000)],
  });
  assert.deepEqual(latest.confirmations, [], "Use the most recent successful reply");
  for (const entries of [
    [successfulUse(180000)],
    [successfulUse(240000)],
    [successfulUse(-1)],
    [successfulUse(1000, { provider: "other" })],
    [successfulUse(1000, { model: "other" })],
    [successfulUse(1000, { stopReason: "error" })],
    [successfulUse(1000, { stopReason: "aborted" })],
    [successfulUse(240000), successfulUse(1000, { stopReason: "error" })],
    [
      {
        type: "model_change",
        provider: expensiveModel.provider,
        modelId: expensiveModel.id,
        timestamp: new Date(Date.now()).toISOString(),
      },
    ],
    [{ ...successfulUse(1000), timestamp: "invalid" }],
  ]) {
    assert.equal(
      (await run({ ...costlyRequest, entries })).confirmations.length,
      1,
      "Only a successful same-provider/model use within three minutes is warm",
    );
  }
  assert.deepEqual(
    (await run({ usage: { tokens: 100000 } })).confirmations,
    [],
    "Cheap context must not ask",
  );
  assert.deepEqual(
    (await run({ destinationModel: expensiveModel, usage: { tokens: 24995 } })).confirmations,
    [],
  );
  assert.equal(
    (await run({ destinationModel: expensiveModel, usage: { tokens: 24996 } })).confirmations
      .length,
    1,
    "The $0.25 boundary includes the new prompt's estimated tokens",
  );
  assert.equal(
    (
      await run({
        destinationModel: expensiveModel,
        usage: { tokens: 0 },
        prompt: "x".repeat(100000),
      })
    ).confirmations.length,
    1,
    "A large new prompt must not bypass the guard",
  );
  for (const usage of [{ tokens: null }, null, { tokens: NaN }, { tokens: -100 }]) {
    const unknown = await run({ ...costlyRequest, usage });
    assert.equal(unknown.confirmations.length, 1);
    assert.match(unknown.confirmations[0][0], /cost: unknown/);
  }
  for (const inputPrice of [NaN, Infinity, -1]) {
    const invalidPrice = await run({
      ...costlyRequest,
      destinationModel: model("strong", { cost: { input: inputPrice, output: 20 } }),
    });
    assert.equal(invalidPrice.confirmations.length, 1);
    assert.match(invalidPrice.confirmations[0][0], /cost: unknown/);
  }
  const unchanged = await run({ ...costlyRequest, currentModel: expensiveModel });
  assert.deepEqual(unchanged.confirmations, [], "Keeping the same model must not ask");
  const headless = await run({ ...costlyRequest, hasUI: false });
  assert.deepEqual(headless.switched, [], "An expensive cold switch without UI must stay put");
  assert.deepEqual(headless.confirmations, []);
  assert.deepEqual(
    (await run({ ...costlyRequest, hasUI: false, entries: [successfulUse(1000)] })).switched,
    [expensiveModel],
  );
  assert.deepEqual((await run({ hasUI: false, usage: { tokens: null } })).switched, []);

  for (const duringConfirmation of [
    (command, ctx) => command.handler("off", ctx),
    (_command, ctx) => {
      ctx.model = textOnly;
    },
  ]) {
    assert.deepEqual((await run({ ...costlyRequest, duringConfirmation })).switched, []);
  }
  const confirmationAbort = new AbortController();
  const cancelledConfirmation = await run({
    ...costlyRequest,
    signal: confirmationAbort.signal,
    duringConfirmation: () => confirmationAbort.abort(),
  });
  assert.equal(cancelledConfirmation.confirmations[0][2].signal, confirmationAbort.signal);
  assert.deepEqual(cancelledConfirmation.switched, []);

  const originalTimeout = AbortSignal.timeout;
  const classifierDeadline = new AbortController();
  AbortSignal.timeout = () => classifierDeadline.signal;
  try {
    const slowConfirmation = await run({
      ...costlyRequest,
      duringConfirmation: () => classifierDeadline.abort(),
    });
    assert.deepEqual(
      slowConfirmation.switched,
      [expensiveModel],
      "The Jev deadline must not time out user confirmation",
    );
  } finally {
    AbortSignal.timeout = originalTimeout;
  }

  process.env.PI_ROUTER_COST_LIMIT_USD = "2";
  assert.deepEqual((await run(costlyRequest)).confirmations, [], "Work can raise the dollar limit");
  process.env.PI_ROUTER_COST_LIMIT_USD = "off";
  assert.deepEqual(
    (await run({ ...costlyRequest, usage: { tokens: null }, hasUI: false })).switched,
    [expensiveModel],
  );
  process.env.PI_ROUTER_COST_LIMIT_USD = "0";
  assert.equal((await run()).confirmations.length, 1);
  for (const limit of ["", " ", "-1", "NaN", "Infinity", "invalid"]) {
    process.env.PI_ROUTER_COST_LIMIT_USD = limit;
    const invalid = await run(costlyRequest);
    assert.deepEqual(invalid.switched, []);
    assert.match(invalid.notices.at(-1)[0], /PI_ROUTER_COST_LIMIT_USD/);
  }
} finally {
  Date.now = originalNow;
  if (originalCostLimit === undefined) delete process.env.PI_ROUTER_COST_LIMIT_USD;
  else process.env.PI_ROUTER_COST_LIMIT_USD = originalCostLimit;
}
console.log("Model router checks passed");

// Optional: exercise the installed pi catalog, auth resolution, and HTTP adapter offline.
if (process.env.PI_ROUTER_TEST_SDK) {
  const { ModelRegistry, ModelRuntime } = await import(process.env.PI_ROUTER_TEST_SDK);
  const runtime = await ModelRuntime.create({
    credentials: { read: async () => undefined, list: async () => [], modify: async (_id, callback) => callback(undefined), delete: async () => {} },
    modelsStore: { read: async () => undefined, write: async () => {}, delete: async () => {} },
    modelsPath: null,
    refreshOnCreate: false,
  });
  await runtime.setRuntimeApiKey("openrouter", "mock-key");
  const registry = new ModelRegistry(runtime);
  assert.ok(registry.findOfType("classifier", "openrouter", decisionModel.id), "Decision model must exist in pi's classifier catalog");
  const originalFetch = globalThis.fetch;
  const requests = [];
  globalThis.fetch = async (url, options) => {
    assert.equal(String(url), "https://openrouter.ai/api/v1/systemone");
    const body = JSON.parse(options.body);
    requests.push(body);
    assert.equal(body.model, decisionModel.id);
    for (const description of Object.values(body.questions.model.criteria)) assert.equal(typeof description, "string");
    return Response.json({ model: body.model, answers: { model: { type: "choice", choice: "test/strong", probabilities: { "test/strong": 1, "test/cheap": 0 }, confidence: 1 } } });
  };
  try {
    const integration = await run({ registry });
    assert.equal(requests.length, 1);
    assert.deepEqual(integration.switched, [b]);
  } finally {
    globalThis.fetch = originalFetch;
  }
  console.log("Real pi classifier protocol checks passed (mock HTTP, no credentials)");
}
