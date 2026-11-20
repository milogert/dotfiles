import assert from "node:assert/strict";
import { mkdtemp, readFile, rmdir } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

assert.ok(process.argv[2], "Pass the built ccmux.js source path as the first argument");
const { makeExtension } = await import(pathToFileURL(process.argv[2]).href);
const directory = await mkdtemp(join(tmpdir(), "ccmux-check-"));
const handlers = {};
const ctx = {
  cwd: directory,
  sessionManager: { getSessionId: () => "synthetic", getSessionFile: () => undefined },
};
makeExtension({ markersDir: directory, version: "test" })({
  on: (event, handler) => { handlers[event] = handler; },
});
const readState = async () => JSON.parse(await readFile(join(directory, "pi-synthetic.json"), "utf8")).state;
try {
  await handlers.session_start({}, ctx);
  assert.equal(await readState(), "idle");
  await handlers.agent_start({}, ctx);
  assert.equal(await readState(), "working");
  await handlers.agent_end?.({}, ctx);
  assert.equal(await readState(), "working", "A run ending must not report idle before queued work/retries settle");
  await handlers.agent_settled({}, ctx);
  assert.equal(await readState(), "idle");
} finally {
  await handlers.session_shutdown({}, ctx);
  await rmdir(directory);
}
console.log("ccmux remains working until agent_settled; marker cleanup passed");
