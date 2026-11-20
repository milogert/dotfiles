import assert from "node:assert/strict";
import gateCheck from "./gate-check.ts";

const handlers = {};
const commands = {};
const prompts = [];
let choices = [];
const ctx = {
  cwd: "/workspace/project",
  hasUI: true,
  ui: {
    select: async (title, options) => {
      prompts.push(title);
      assert.deepEqual(options, ["Block", "Confirm", "Confirm for session"]);
      assert.ok(choices.length, "Unexpected approval prompt");
      return choices.shift();
    },
    confirm: async () => {
      throw new Error("Gate-check must offer session approval, not a yes/no dialog");
    },
    notify: () => {},
  },
};
gateCheck({
  on: (event, handler) => {
    handlers[event] = handler;
  },
  registerCommand: (name, command) => {
    commands[name] = command;
  },
});
const write = (path, toolName = "write") => handlers.tool_call({ toolName, input: { path } }, ctx);
const bash = (command) => handlers.tool_call({ toolName: "bash", input: { command } }, ctx);
const userBash = (command) => handlers.user_bash({ command }, ctx);
const configure = (args) => commands["gate-check"].handler(args, ctx);

choices = ["Block", undefined, "Confirm", "Block"];
assert.equal((await write("/tmp/once.txt")).block, true);
assert.equal((await write("/tmp/once.txt")).block, true, "Cancellation must block");
assert.equal(await write("/tmp/once.txt"), undefined);
assert.equal((await write("/tmp/once.txt")).block, true, "Confirm is one-shot");

choices = ["Confirm for session"];
assert.equal(await write("/tmp/first.txt"), undefined);
assert.match(prompts.at(-1), /Session approval: \/tmp$/);
const directoryPromptCount = prompts.length;
assert.equal(await write("/tmp/second.txt", "edit"), undefined);
assert.equal(await write("/tmp/nested/third.txt"), undefined);
assert.equal(prompts.length, directoryPromptCount, "Directory approval covers descendants");
choices = ["Block", "Block"];
assert.equal((await write("/tmp-other/file.txt")).block, true, "No prefix sibling approval");
assert.equal((await write("/elsewhere/file.txt")).block, true);

choices = ["Block", "Confirm for session", "Block"];
assert.equal((await write("/tmp/.env")).block, true, "Directory approval cannot bypass secrets");
assert.equal(await write("/tmp/.env"), undefined);
assert.equal(await write("/tmp/.env", "edit"), undefined);
assert.equal((await write("/tmp/.env.local")).block, true, "Secret approval is exact-path only");
choices = ["Confirm", "Block"];
assert.equal(
  (await write("/outside/.env")).block,
  true,
  "One-shot outside approval still checks secrets",
);

choices = ["Confirm for session", "Block", "Confirm", "Block"];
assert.equal(await bash("git push origin main"), undefined);
assert.equal(await userBash("git push origin main"), undefined, "Both shell paths share approvals");
assert.equal((await bash("git push origin other")).block, true);
assert.equal(await userBash("git commit -m test"), undefined);
assert.equal((await bash("git commit -m test")).block, true, "Shell Confirm is one-shot");
choices = ["Confirm for session"];
assert.equal(await userBash("chmod 600 file.txt"), undefined);
assert.equal(await bash("chmod 600 file.txt"), undefined);

ctx.hasUI = false;
assert.equal(await write("/tmp/approved.txt"), undefined);
assert.equal((await write("/unapproved/file.txt")).block, true);
assert.equal((await bash("sudo true")).block, true);
assert.equal((await userBash("sudo true")).result.exitCode, 1);
assert.equal(await bash("echo safe"), undefined);
ctx.hasUI = true;

await handlers.session_start({}, ctx);
choices = ["Block", "Block", "Block"];
assert.equal(
  (await write("/tmp/first.txt")).block,
  true,
  "Session start clears directory approvals",
);
assert.equal((await bash("git push origin main")).block, true, "Session start clears commands");
await configure("edit-outside-directory add /tmp");
assert.equal((await write("/tmp/.env")).block, true, "Session start clears secret approvals");
assert.equal(await write("/tmp/file.txt"), undefined);
await configure("edit-outside-directory remove /tmp");
choices = ["Confirm for session", "Block"];
assert.equal(await write("/tmp/file.txt"), undefined);
await configure("edit-outside-directory reset");
assert.equal(
  (await write("/tmp/file.txt")).block,
  true,
  "Reset revokes directory session approval",
);
await configure("edit-outside-directory add /tmp /other");
assert.equal(await write("/tmp/file.txt"), undefined);
assert.equal(await write("/other/file.txt"), undefined);
assert.deepEqual(choices, []);
console.log("Gate-check one-shot, session scope, independent gates, and reset checks passed");
