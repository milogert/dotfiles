import assert from "node:assert/strict";
import planMode from "./plan-mode-lite.ts";

const handlers = {};
const commands = {};
const notices = [];
const statuses = [];
const messages = [];
let branch = [];
let idle = true;
const unrelatedAcceptance = { type: "custom", customType: "plan-mode-lite", data: { enabled: true, accepted: true } };
const ctx = {
  hasUI: true,
  isIdle: () => idle,
  sessionManager: { getBranch: () => branch, getEntries: () => [...branch, unrelatedAcceptance] },
  ui: { notify: (...args) => notices.push(args), setStatus: (...args) => statuses.push(args) },
};
planMode({
  on: (event, handler) => { handlers[event] = handler; },
  registerCommand: (name, command) => { commands[name] = command; },
  appendEntry: (customType, data) => branch.push({ type: "custom", customType, data: { ...data } }),
  sendUserMessage: (...args) => messages.push(args),
});
const writeBlocked = () => handlers.tool_call({ toolName: "write" }, ctx)?.block === true;
const promptSection = () => {
  const event = { systemPromptOptions: { sections: {} } };
  assert.equal(handlers.before_agent_start(event, ctx), undefined, "Use structured prompt sections, not a forced system prompt");
  return event.systemPromptOptions.sections["plan-mode"];
};

await handlers.session_start({}, ctx);
assert.equal(writeBlocked(), true, "Acceptance on an abandoned branch must not unlock this branch");
assert.equal(handlers.tool_call({ toolName: "edit" }, ctx).block, true);
assert.equal(handlers.tool_call({ toolName: "bash" }, ctx), undefined, "Planning mode is not a shell sandbox");
assert.match(promptSection(), /no plan has been accepted/);
assert.match(promptSection(), /Do not use `ask_user` or an approval picker for plan approval/);
assert.match(promptSection(), /End your response by telling the user to run `\/planmode execute`/);
assert.match(promptSection(), /Use `ask_user` for requirements questions/);

idle = false;
await commands.planmode.handler("execute", ctx);
assert.equal(writeBlocked(), true);
assert.deepEqual(messages, []);
assert.equal(notices.at(-1)[1], "warning");
idle = true;
await commands.planmode.handler("accept", ctx);
assert.equal(writeBlocked(), false);
assert.match(promptSection(), /current plan has been accepted/);
assert.ok(!notices.at(-1)[0].includes("Auto mode"));
assert.deepEqual(messages, [], "Accept must not start execution");
const acceptedBranch = [...branch];

await commands.planmode.handler("reset", ctx);
assert.equal(writeBlocked(), true);
branch = acceptedBranch;
await handlers.session_tree({}, ctx);
assert.equal(writeBlocked(), false, "Tree navigation must restore acceptance on the target branch");
branch = [];
await handlers.session_tree({}, ctx);
assert.equal(writeBlocked(), true, "Tree navigation must revoke acceptance absent from the target branch");

await commands.planmode.handler("execute", ctx);
assert.equal(writeBlocked(), false);
assert.equal(messages.length, 1);
assert.equal(messages[0][1].deliverAs, "followUp");
await commands.planmode.handler("off", ctx);
assert.equal(promptSection(), undefined);
assert.equal(writeBlocked(), false);
const disabledBranch = [...branch];
await commands.planmode.handler("on", ctx);
assert.equal(writeBlocked(), true);
branch = disabledBranch;
await handlers.session_start({}, ctx);
assert.equal(promptSection(), undefined, "Reload/resume must restore disabled mode");
assert.deepEqual(statuses.at(-1), ["plan-mode", undefined]);
assert.ok(commands.planmode.getArgumentCompletions("r").some(entry => entry.value === "reset"));
console.log("Plan mode branch, approval, execution, and prompt checks passed");
