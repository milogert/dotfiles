import assert from "node:assert/strict";
import { execFileSync, spawn } from "node:child_process";
import { createHash } from "node:crypto";
import { once } from "node:events";
import { mkdirSync, mkdtempSync, realpathSync, statSync, utimesSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { mock } from "node:test";
import cacheStatus from "../cache-status.ts";
import { Coordinator, selectWatch } from "./coordination.ts";
import { collectFeedback } from "./feedback.ts";
import { githubRepository, pushedReflog } from "./git.ts";
import prWatch, { isWithinPollingHours } from "./index.ts";

// Exercises PR discovery, ownership, scheduling, feedback safety, and cache status.

for (let day = 18; day <= 24; day++) {
  const weekday = day <= 22;
  assert.equal(isWithinPollingHours(new Date(2027, 0, day, 7, 59, 59)), false);
  assert.equal(isWithinPollingHours(new Date(2027, 0, day, 8)), weekday);
  assert.equal(isWithinPollingHours(new Date(2027, 0, day, 12)), weekday);
  assert.equal(isWithinPollingHours(new Date(2027, 0, day, 17, 29, 59)), weekday);
  assert.equal(isWithinPollingHours(new Date(2027, 0, day, 17, 30)), false);
  assert.equal(isWithinPollingHours(new Date(2027, 0, day, 23)), false);
}

const directory = realpathSync(mkdtempSync(join(tmpdir(), "pi-pr-watch-test-")));
const sha = "a".repeat(40);
const nextSha = "b".repeat(40);
const epoch = new Date(2027, 0, 18, 8).getTime();
const epochSeconds = Math.floor(epoch / 1000);
const member = { pid: process.pid };
const push = {
  branch: "feature",
  ref: "refs/remotes/origin/feature",
  repository: "owner/repo",
  head: "feature",
  sha,
  token: "push-1",
  pushedAt: epoch,
};

assert.equal(githubRepository("git@github.com:owner/repo.git"), "owner/repo");
assert.equal(githubRepository("https://github.com/owner/repo.git"), "owner/repo");
assert.equal(githubRepository("ssh://git@github.com/owner/repo.git"), "owner/repo");
assert.equal(githubRepository("https://github.com.evil/owner/repo.git"), undefined);
assert.equal(githubRepository("git@gitlab.com:owner/repo.git"), undefined);
const reflog = `refs/remotes/origin/feature@{1800000001 +0000}\t${sha}\tfetch: fast-forward\nrefs/remotes/origin/feature@{1800000000 +0000}\t${sha}\tupdate by push`;
assert.equal(pushedReflog(reflog).sha, sha, "A fetch after a push must not hide the push");
assert.equal(pushedReflog(reflog.split("\n")[0]), undefined, "Fetches must not trigger watching");
assert.equal(pushedReflog("bad\tinvalid\tupdate by push"), undefined);

// Exercise the actual Git reflog format without contacting or pushing to a remote.
const repository = join(directory, "checkout");
execFileSync("git", ["init", "--quiet", repository]);
/** Runs a Git command against the temporary test repository. */
const git = (...args) =>
  execFileSync("git", ["-C", repository, ...args], { encoding: "utf8" }).trim();
git(
  "-c",
  "user.name=Test",
  "-c",
  "user.email=test@example.invalid",
  "commit",
  "--quiet",
  "--allow-empty",
  "-m",
  "test",
);
const actualSha = git("rev-parse", "HEAD");
git(
  "update-ref",
  "--create-reflog",
  "-m",
  "update by push",
  "refs/remotes/origin/feature",
  actualSha,
);
assert.equal(
  pushedReflog(
    git("reflog", "show", "--date=raw", "--format=%gD%x09%H%x09%gs", "refs/remotes/origin/feature"),
  ).sha,
  actualSha,
);

const coordinator = new Coordinator(directory, repository);
assert.equal(
  coordinator.update((state) => selectWatch(state, "first", member)),
  undefined,
);
assert.equal(
  coordinator.update((state) => state.owner),
  "first",
  "The first session must claim the checkout before any push",
);
assert.equal(
  coordinator.update((state) => selectWatch(state, "second", member, push)),
  undefined,
  "Standby sessions cannot create or replace the owner's watch",
);
assert.equal(
  coordinator.update((state) => selectWatch(state, "first", member, push)).owner,
  "first",
);
assert.equal(
  coordinator.update((state) =>
    selectWatch(state, "first", member, { ...push, branch: "other", token: "other-push" }),
  ).branch,
  "other",
  "Before a PR is found, lookup should follow the current branch",
);
coordinator.update((state) => {
  selectWatch(state, "first", member, push);
  state.watch.number = 1;
  state.watch.seen.push("delivered");
});
assert.equal(
  coordinator.update((state) =>
    selectWatch(state, "first", member, { ...push, branch: "other", token: "other-push" }),
  ).branch,
  "feature",
  "Branch changes must not retarget the pinned PR",
);
assert.deepEqual(
  coordinator.update((state) =>
    selectWatch(state, "first", member, { ...push, token: "push-2", sha: nextSha }),
  ).seen,
  ["delivered"],
  "New pushes must preserve delivered feedback",
);
coordinator.update((state) => {
  delete state.members.first;
  delete state.owner;
});
const adopted = coordinator.update((state) => selectWatch(state, "second", member));
assert.equal(adopted.owner, "second", "A waiting session must adopt a released PR");
assert.deepEqual(adopted.seen, ["delivered"]);
assert.equal(adopted.lastPoll, 0, "Takeover must not wait for the previous owner's poll interval");

// Use a real, exited child PID: stale heartbeats must never evict a living process.
const child = spawn(process.execPath, ["-e", ""], { stdio: "ignore" });
await once(child, "exit");
coordinator.update((state) => {
  state.members.second.pid = child.pid;
  state.members.waiter = member;
});
assert.equal(
  coordinator.update((state) => selectWatch(state, "waiter", member)).owner,
  "waiter",
  "Dead processes must release ownership without a heartbeat timeout",
);

const coordinatorDirectory = join(directory, createHash("sha256").update(repository).digest("hex"));
const mutex = join(coordinatorDirectory, "lock");
mkdirSync(mutex);
writeFileSync(join(mutex, "pid"), String(process.pid));
utimesSync(mutex, new Date(0), new Date(0));
assert.equal(
  coordinator.update(() => assert.fail("A live mutex must not be stolen")),
  undefined,
);
assert.ok(statSync(mutex).isDirectory(), "Elapsed time alone cannot release a live mutex");
writeFileSync(join(mutex, "pid"), String(child.pid));
assert.equal(
  coordinator.update(() => assert.fail("Recovery must retry acquisition")),
  undefined,
);
assert.equal(
  coordinator.update(() => true),
  true,
  "An abandoned mutex must be recoverable",
);

// Exercise simultaneous claims and JSON writes in separate, living Pi-like processes.
const racingCheckout = join(directory, "racing-checkout");
const racingCoordinator = new Coordinator(directory, racingCheckout);
const workerSource = `
  import { once } from "node:events";
  import { setTimeout } from "node:timers/promises";
  import { Coordinator, selectWatch } from ${JSON.stringify(new URL("./coordination.ts", import.meta.url).href)};
  const coordinator = new Coordinator(${JSON.stringify(directory)}, ${JSON.stringify(racingCheckout)});
  process.stdout.write("ready\\n");
  await once(process.stdin, "data");
  for (let count = 0; count < 20;) {
    const updated = coordinator.update(state => {
      const selected = selectWatch(state, String(process.pid), { pid: process.pid }, ${JSON.stringify(push)});
      state.updates = (state.updates ?? 0) + 1;
      if (selected) state.pollingOwners = [...new Set([...(state.pollingOwners ?? []), selected.owner])];
      return true;
    });
    if (updated) count++;
    await setTimeout(1);
  }
  process.stdout.write("done\\n");
  await once(process.stdin, "data");
  process.exit(0);
`;
const workers = Array.from({ length: 4 }, () =>
  spawn(
    process.execPath,
    ["--experimental-strip-types", "--input-type=module", "-e", workerSource],
    { stdio: ["pipe", "pipe", "inherit"] },
  ),
);
try {
  await Promise.all(
    workers.map((worker) => once(worker.stdout, "data", { signal: AbortSignal.timeout(10000) })),
  );
  const finished = workers.map((worker) =>
    once(worker.stdout, "data", { signal: AbortSignal.timeout(10000) }),
  );
  workers.forEach((worker) => {
    worker.stdin.write("start\n");
  });
  await Promise.all(finished);
  const racingState = racingCoordinator.update((state) => structuredClone(state));
  assert.equal(racingState.updates, 80, "Concurrent state updates must not be lost");
  assert.deepEqual(
    racingState.pollingOwners,
    [racingState.owner],
    "Only one live process may own PR polling",
  );
  const exited = workers.map((worker) => once(worker, "exit"));
  workers.forEach((worker) => {
    worker.stdin.write("exit\n");
  });
  await Promise.all(exited);
} finally {
  workers.forEach((worker) => {
    if (worker.exitCode === null) worker.kill();
  });
}

const failure = {
  name: "tests",
  conclusion: "FAILURE",
  detailsUrl: "https://github.com/owner/repo/actions/runs/1",
  completedAt: "2027-01-15T08:01:00Z",
};
const comment = {
  html_url: "https://github.com/owner/repo/pull/1#issuecomment-1",
  updated_at: new Date(epoch + 1000).toISOString(),
  body: "Please fix",
  user: { login: "reviewer" },
};
const review = {
  id: 1,
  state: "CHANGES_REQUESTED",
  submitted_at: new Date(epoch + 1000).toISOString(),
  body: "Needs changes",
};
const feedback = collectFeedback(
  [failure, { conclusion: "SUCCESS" }],
  [comment, { ...comment, updated_at: new Date(epoch - 1000).toISOString() }],
  [review, { ...review, state: "APPROVED" }],
  epoch,
);
assert.deepEqual(
  feedback.map((item) => item.kind),
  ["CI failure", "comment", "review"],
);
assert.notEqual(
  collectFeedback(
    [],
    [{ ...comment, updated_at: new Date(epoch + 2000).toISOString() }],
    [],
    epoch,
  )[0].key,
  feedback[1].key,
  "Edited comments must be delivered again",
);

mock.timers.enable({ apis: ["Date", "setTimeout", "setInterval"], now: epoch });
const oldAgentDirectory = process.env.PI_CODING_AGENT_DIR;
process.env.PI_CODING_AGENT_DIR = join(directory, "agent");
let remoteSha = sha;
let localSha = sha;
let branch = "feature";
let log = `refs/remotes/origin/feature@{${epochSeconds - 100} +0000}\t${sha}\tupdate by push`;
let pullState = "OPEN";
let availablePull = true;
let apiFailure = false;
const historicalFailure = {
  ...failure,
  detailsUrl: "https://github.com/owner/repo/actions/runs/0",
};
const historicalReview = { ...review, submitted_at: new Date(epoch - 1000).toISOString() };
let checks = [historicalFailure];
let comments = [{ ...comment, updated_at: new Date(epoch - 1000).toISOString() }];
let reviews = [historicalReview];
let apiCalls = 0;
let gitCalls = 0;
let closeWindowAfterPull;
let closeWindowAfterReviews;
const statuses = new Map();
const notices = [];
const messages = [];
let idle = true;
const handlers = {};
const commands = {};
const entries = [{ type: "message", timestamp: new Date(epoch - 1000).toISOString() }];
const ctx = {
  cwd: repository,
  hasUI: true,
  isIdle: () => idle,
  sessionManager: { getBranch: () => entries },
  ui: {
    setStatus: (key, value) => statuses.set(key, value),
    notify: (...args) => notices.push(args),
  },
};
const pi = {
  on: (event, handler) => {
    handlers[event] = handler;
  },
  registerCommand: (name, command) => {
    commands[name] = command;
  },
  sendMessage: (...args) => messages.push(args),
  getSettings: () => ({ cacheWarming: "idle" }),
  // Emulates Git and GitHub responses for extension lifecycle tests.
  exec: async (command, args, options) => {
    assert.equal(options.cwd, repository);
    assert.ok(options.signal instanceof AbortSignal);
    let stdout;
    if (command === "git") {
      gitCalls++;
      if (args[0] === "symbolic-ref") stdout = branch;
      else if (args[0] === "for-each-ref") stdout = "\trefs/remotes/origin/feature";
      else if (args[0] === "remote") stdout = "git@github.com:owner/repo.git";
      else if (args[0] === "reflog") stdout = log;
      else if (args[1] === "--show-toplevel") stdout = repository;
      else if (args[0] === "rev-parse") stdout = localSha;
      else assert.fail(`Unexpected Git command: ${args}`);
    } else {
      assert.equal(command, "gh");
      assert.ok(isWithinPollingHours(), "No new GitHub request may start outside working hours");
      apiCalls++;
      if (apiFailure) return { code: 1, stderr: "rate limited", stdout: "" };
      if (args[0] === "repo") stdout = "owner/repo";
      else if (args[0] === "pr") {
        stdout = JSON.stringify({
          state: pullState,
          headRefOid: remoteSha,
          statusCheckRollup: checks,
        });
        if (closeWindowAfterPull) {
          mock.timers.setTime(closeWindowAfterPull);
          closeWindowAfterPull = undefined;
        }
      } else if (args.at(-1).includes("state=open"))
        stdout = JSON.stringify([
          availablePull
            ? [{ number: 1, head: { sha: remoteSha, repo: { full_name: "owner/repo" } } }]
            : [],
        ]);
      else if (args.at(-1).includes("/reviews?")) {
        stdout = JSON.stringify([reviews]);
        if (closeWindowAfterReviews) {
          mock.timers.setTime(closeWindowAfterReviews);
          closeWindowAfterReviews = undefined;
        }
      } else stdout = JSON.stringify([args.at(-1).includes("issues/") ? comments : []]);
    }
    return { code: 0, stdout, stderr: "" };
  },
};
/** Advances mocked timers and flushes asynchronous poll work. */
const advance = async (milliseconds) => {
  mock.timers.tick(milliseconds);
  for (let index = 0; index < 150; index++) await Promise.resolve();
};
/** Advances mocked time to a local calendar date and time. */
const advanceTo = (date) => advance(date.getTime() - Date.now());
try {
  prWatch(pi);
  await handlers.session_start({}, ctx);
  assert.equal(
    messages.length,
    0,
    "Startup must baseline existing CI failures, comments, and reviews without starting a turn",
  );
  await advance(30000);
  assert.equal(
    messages.length,
    0,
    "Existing feedback must remain suppressed after the startup poll",
  );
  await advance(5000);
  assert.ok(apiCalls > 0, "Startup must discover and poll an already-pushed PR immediately");
  const startupCalls = apiCalls;
  log = `refs/remotes/origin/feature@{${epochSeconds + 5} +0000}\t${sha}\tfetch: fast-forward\n${log}`;
  await advance(5000);
  assert.equal(apiCalls, startupCalls, "Fetches must not bypass the GitHub poll interval");
  log = `refs/remotes/origin/feature@{${epochSeconds + 10} +0000}\t${sha}\tupdate by push`;
  availablePull = false;
  await advance(5000);
  assert.equal(messages.length, 0);
  availablePull = true;
  checks = [historicalFailure, failure];
  comments = [{ ...comment, updated_at: new Date(epoch + 11000).toISOString() }];
  reviews = [historicalReview, { ...review, id: 2 }];
  idle = false;
  await advance(30000);
  assert.equal(messages.length, 0, "Busy agents must not receive stale queued feedback");
  idle = true;
  await advance(30000);
  assert.equal(messages.length, 1);
  assert.deepEqual(messages[0][1], { triggerTurn: true, deliverAs: "followUp" });
  assert.match(messages[0][0].content, /untrusted data/);
  assert.match(messages[0][0].content, /Do not commit, push/);
  const firstBatch = JSON.parse(messages[0][0].content.split("\n").at(-1));
  assert.deepEqual(
    firstBatch.map((item) => item.kind),
    ["CI failure", "comment", "review"],
    "Only new failures, edited comments, and new reviews should wake the agent",
  );
  assert.equal(notices.filter(([text]) => text.startsWith("Watching PR #1")).length, 1);
  assert.match(statuses.get("pr-watch"), /PR #1/);
  await advance(30000);
  assert.equal(messages.length, 1, "Unchanged failures/comments must be deduplicated");
  comments[0].updated_at = new Date(Date.now()).toISOString();
  localSha = nextSha;
  await advance(30000);
  assert.equal(messages.length, 1, "A changed local HEAD must prevent autonomous edits");
  localSha = sha;
  apiFailure = true;
  await advance(30000);
  assert.equal(statuses.get("pr-watch"), "PR watch: error");
  await advance(5000);
  await advance(25000);
  assert.equal(
    notices.filter(([text]) => text.includes("rate limited")).length,
    1,
    "Repeated API errors must not spam notifications",
  );
  apiFailure = false;
  await advance(30000);
  assert.equal(messages.length, 2, "Retry must recover without losing edited feedback");
  remoteSha = nextSha;
  await advance(30000);
  assert.match(
    statuses.get("pr-watch"),
    /PR #1/,
    "Remote commits must not end monitoring of the pinned PR",
  );
  assert.equal(messages.length, 2, "A remote HEAD mismatch must not dispatch feedback");
  localSha = nextSha;
  log = `refs/remotes/origin/feature@{${Math.floor(Date.now() / 1000)} +0000}\t${nextSha}\tupdate by push`;
  checks = [];
  comments = [];
  await advance(5000);
  await advance(5000);
  assert.equal(
    statuses.get("pr-watch"),
    "PR #1",
    "Another push keeps the same PR without a deadline",
  );
  pullState = "CLOSED";
  await advance(30000);
  assert.equal(statuses.get("pr-watch"), "PR #1 | closed");
  pullState = "OPEN";
  log = `refs/remotes/origin/feature@{${Math.floor(Date.now() / 1000)} +0000}\t${nextSha}\tupdate by push`;
  await advance(5000);
  await commands["pr-watch"].handler("stop", ctx);
  const callsAtStop = apiCalls;
  await advance(30000);
  assert.equal(apiCalls, callsAtStop, "Manual stop must suppress GitHub polling");
  await commands["pr-watch"].handler("start", ctx);
  await advance(30000);
  assert.ok(apiCalls > callsAtStop, "Start must resume the pinned PR, not wait for another push");
  const callsBeforeDeadline = apiCalls;
  await advance(21 * 60000);
  assert.ok(apiCalls > callsBeforeDeadline, "Monitoring must continue beyond 20 minutes");
  assert.equal(statuses.get("pr-watch"), "PR #1");

  const waitingHandlers = {};
  const waitingStatuses = new Map();
  const waitingMessages = [];
  const waitingContext = {
    ...ctx,
    ui: { ...ctx.ui, setStatus: (key, value) => waitingStatuses.set(key, value) },
  };
  prWatch({
    ...pi,
    on: (event, handler) => {
      waitingHandlers[event] = handler;
    },
    sendMessage: (...args) => waitingMessages.push(args),
  });
  const callsBeforeWaiting = apiCalls;
  await waitingHandlers.session_start({}, waitingContext);
  await advance(5000);
  assert.equal(
    apiCalls,
    callsBeforeWaiting,
    "A second live session must remain standby even after long idle periods",
  );
  assert.equal(waitingStatuses.get("pr-watch"), "PR watch: standby");

  branch = "other";
  checks = [failure];
  comments = [{ ...comment, updated_at: new Date(Date.now()).toISOString() }];
  const beforeBranchChange = messages.length;
  await advance(30000);
  assert.equal(
    messages.length,
    beforeBranchChange,
    "Monitoring a pinned PR after switching branches must not dispatch edits",
  );
  assert.equal(waitingMessages.length, 0);
  const callsAtShutdown = apiCalls;
  await handlers.session_shutdown({}, ctx);
  await advance(5000);
  assert.ok(
    apiCalls > callsAtShutdown,
    "A waiting session must poll the same PR on its next tick after owner shutdown",
  );
  assert.equal(waitingStatuses.get("pr-watch"), "PR #1");
  assert.equal(
    waitingMessages.length,
    0,
    "An adopted PR still requires a matching branch and HEAD",
  );
  branch = "feature";
  await advance(30000);
  assert.equal(waitingMessages.length, 1);
  await advance(30000);
  assert.equal(waitingMessages.length, 1, "Adoption must retain cross-session deduplication");
  await waitingHandlers.session_shutdown({}, waitingContext);
  const callsAfterShutdown = apiCalls;
  await advance(60000);
  assert.equal(apiCalls, callsAfterShutdown, "Shutdown must cancel every background timer");

  // An empty first snapshot must still establish a baseline, even with a stale local HEAD.
  log = "";
  localSha = sha;
  remoteSha = nextSha;
  checks = [];
  comments = [];
  reviews = [];
  const noReflogHandlers = {};
  prWatch({
    ...pi,
    on: (event, handler) => {
      noReflogHandlers[event] = handler;
    },
  });
  const callsBeforeDiscovery = apiCalls;
  await noReflogHandlers.session_start({}, ctx);
  assert.ok(apiCalls > callsBeforeDiscovery);
  assert.equal(
    messages.length,
    beforeBranchChange,
    "Startup with an unpushed or stale local HEAD must not dispatch edits",
  );
  await advance(5000);
  assert.equal(
    statuses.get("pr-watch"),
    "PR #1",
    "Discovery must not require a local push reflog or matching local SHA",
  );
  localSha = nextSha;
  checks = [failure];
  await advance(30000);
  assert.equal(
    messages.length,
    beforeBranchChange + 1,
    "New feedback after an empty baseline must still start a turn",
  );
  await noReflogHandlers.session_shutdown({}, ctx);

  // A fresh launch while busy must baseline old feedback before the agent becomes idle.
  const busyStartupHandlers = {};
  idle = false;
  prWatch({
    ...pi,
    on: (event, handler) => {
      busyStartupHandlers[event] = handler;
    },
  });
  await busyStartupHandlers.session_start({}, ctx);
  idle = true;
  await advance(30000);
  assert.equal(
    messages.length,
    beforeBranchChange + 1,
    "Fresh sessions must not replay old failures when they become idle",
  );
  await busyStartupHandlers.session_shutdown({}, ctx);

  // Startup errors must leave baselining pending until the first complete successful snapshot.
  const retryStartupHandlers = {};
  apiFailure = true;
  prWatch({
    ...pi,
    on: (event, handler) => {
      retryStartupHandlers[event] = handler;
    },
  });
  await retryStartupHandlers.session_start({}, ctx);
  apiFailure = false;
  await advance(30000);
  await advance(30000);
  assert.equal(
    messages.length,
    beforeBranchChange + 1,
    "Recovering from a startup API error must baseline rather than replay existing feedback",
  );
  await retryStartupHandlers.session_shutdown({}, ctx);

  // Keep the same watch across a night and weekend instead of baselining new feedback away.
  await advanceTo(new Date(2027, 0, 18, 17, 29));
  checks = [];
  comments = [];
  reviews = [];
  const scheduledHandlers = {};
  prWatch({
    ...pi,
    on: (event, handler) => {
      scheduledHandlers[event] = handler;
    },
  });
  await scheduledHandlers.session_start({}, ctx);
  const callsBeforeNight = apiCalls;
  const gitCallsBeforeNight = gitCalls;
  const messagesBeforeNight = messages.length;
  await advanceTo(new Date(2027, 0, 18, 17, 30));
  assert.equal(apiCalls, callsBeforeNight, "GitHub polling must stop at 17:30 local time");
  assert.equal(
    gitCalls,
    gitCallsBeforeNight,
    "Local Git polling must also stop outside working hours",
  );
  assert.equal(statuses.get("pr-watch"), "PR watch: outside working hours");
  remoteSha = sha;
  localSha = sha;
  log = `refs/remotes/origin/feature@{${Math.floor(Date.now() / 1000)} +0000}\t${sha}\tupdate by push`;
  checks = [failure];
  comments = [{ ...comment, updated_at: new Date(Date.now()).toISOString() }];
  await advanceTo(new Date(2027, 0, 19, 7, 59, 59));
  assert.equal(apiCalls, callsBeforeNight, "Nights and early mornings must not poll GitHub");
  assert.equal(gitCalls, gitCallsBeforeNight);
  await advanceTo(new Date(2027, 0, 19, 8));
  await advance(5000);
  assert.ok(apiCalls > callsBeforeNight, "Polling must resume at 08:00 on weekdays");
  assert.equal(
    messages.length,
    messagesBeforeNight + 1,
    "Overnight feedback and pushes must be actionable, not rebaselined on resume",
  );
  await advance(30000);
  assert.equal(
    messages.length,
    messagesBeforeNight + 1,
    "Resumed feedback must still be deduplicated",
  );

  // Stop a multi-command poll quietly if an earlier command finishes after closing time.
  closeWindowAfterPull = new Date(2027, 0, 21, 17, 30).getTime();
  const callsBeforeCutoff = apiCalls;
  const warningsBeforeCutoff = notices.filter(([, level]) => level === "warning").length;
  await advanceTo(new Date(2027, 0, 21, 17, 29, 30));
  assert.equal(
    apiCalls,
    callsBeforeCutoff + 1,
    "No more gh commands may start when a poll crosses closing time",
  );
  assert.equal(
    notices.filter(([, level]) => level === "warning").length,
    warningsBeforeCutoff,
    "Scheduled suspension must not warn as an API error",
  );

  // A poll may finish after closing time; keep its feedback pending until the next window.
  comments[0].updated_at = new Date(2027, 0, 22, 17, 29, 30).toISOString();
  closeWindowAfterReviews = new Date(2027, 0, 22, 17, 30).getTime();
  await advanceTo(new Date(2027, 0, 22, 17, 29, 30));
  assert.equal(
    messages.length,
    messagesBeforeNight + 1,
    "A poll crossing closing time must not start an off-hours turn",
  );
  await advance(5000);
  const weekendHandlers = {};
  prWatch({
    ...pi,
    on: (event, handler) => {
      weekendHandlers[event] = handler;
    },
  });
  await weekendHandlers.session_start({}, ctx);
  await scheduledHandlers.session_shutdown({}, ctx);
  const callsBeforeWeekend = apiCalls;
  const gitCallsBeforeWeekend = gitCalls;
  await advanceTo(new Date(2027, 0, 23, 12));
  await advanceTo(new Date(2027, 0, 24, 12));
  await advanceTo(new Date(2027, 0, 25, 7, 59, 59));
  assert.equal(
    apiCalls,
    callsBeforeWeekend,
    "Saturday, Sunday, and Monday before 08:00 must not poll",
  );
  assert.equal(gitCalls, gitCallsBeforeWeekend);
  assert.equal(
    statuses.get("pr-watch"),
    "PR watch: outside working hours",
    "Ownership can transfer while polling is suspended",
  );
  await advanceTo(new Date(2027, 0, 25, 8));
  await advance(5000);
  assert.equal(
    messages.length,
    messagesBeforeNight + 2,
    "Pending Friday feedback must survive both the weekend and an off-hours takeover",
  );
  await advance(30000);
  assert.equal(messages.length, messagesBeforeNight + 2);
  await weekendHandlers.session_shutdown({}, ctx);

  const cacheHandlers = {};
  let cacheMode = "idle";
  cacheStatus({
    on: (event, handler) => {
      cacheHandlers[event] = handler;
    },
    getSettings: () => ({ cacheWarming: cacheMode }),
  });
  cacheHandlers.session_start({}, ctx);
  assert.equal(statuses.get("cache-warming"), "cache: idle | awaiting decision");
  assert.equal(
    cacheHandlers.cache_warming_decision({ action: "warm" }, ctx),
    undefined,
    "Status must never change warming policy",
  );
  assert.equal(statuses.get("cache-warming"), "cache: idle | refresh requested");
  entries.push({
    type: "usage",
    kind: "cache_warm",
    timestamp: new Date(Date.now() + 1).toISOString(),
  });
  await advance(5000);
  assert.match(statuses.get("cache-warming"), /refreshed 0m ago/);
  cacheHandlers.cache_warming_decision({ action: "stop" }, ctx);
  assert.equal(statuses.get("cache-warming"), "cache: idle | stopped");
  cacheMode = "off";
  await advance(5000);
  assert.equal(statuses.get("cache-warming"), "cache: off");
  cacheHandlers.session_shutdown({}, ctx);
  await advance(5000);
  assert.equal(statuses.get("cache-warming"), undefined);
} finally {
  mock.timers.reset();
  if (oldAgentDirectory === undefined) delete process.env.PI_CODING_AGENT_DIR;
  else process.env.PI_CODING_AGENT_DIR = oldAgentDirectory;
}
console.log(
  "PR detection, ownership, feedback safety, deduplication, recovery, cleanup, and cache status checks passed",
);
