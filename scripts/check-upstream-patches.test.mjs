import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { checkPatch } from "./check-upstream-patches.mjs";

const commit = "a".repeat(40);
const release = {
  tag_name: "v2.0.0",
  html_url: "https://github.com/owner/repo/releases/tag/v2.0.0",
};
const patch = { name: "test patch", file: "test.nix", repo: "owner/repo", kind: "commit", commit };
const requests = [];

function api(responses) {
  return async (endpoint) => {
    requests.push(endpoint);
    assert.ok(Object.hasOwn(responses, endpoint), `Unexpected GitHub request: ${endpoint}`);
    return responses[endpoint];
  };
}

for (const status of ["ahead", "identical"]) {
  const result = await checkPatch(
    patch,
    api({
      "repos/owner/repo/releases/latest": release,
      [`repos/owner/repo/compare/${commit}...v2.0.0`]: { status },
    }),
  );
  assert.equal(result.status, "RELEASED");
  assert.match(result.detail, /review test.nix/);
}

for (const status of ["behind", "diverged"]) {
  const result = await checkPatch(
    patch,
    api({
      "repos/owner/repo/releases/latest": release,
      [`repos/owner/repo/compare/${commit}...v2.0.0`]: { status },
    }),
  );
  assert.equal(
    result.status,
    "NOT-RELEASED",
    "A newer release alone does not prove the fix is included",
  );
}

const pullPatch = { ...patch, kind: "pull", number: 42 };
requests.length = 0;
assert.equal(
  (
    await checkPatch(
      pullPatch,
      api({
        "repos/owner/repo/pulls/42": { state: "open", merged: false, html_url: "PR URL" },
      }),
    )
  ).status,
  "OPEN",
);
assert.equal(requests.length, 1, "Unmerged PRs do not need a release lookup");
assert.equal(
  (
    await checkPatch(
      pullPatch,
      api({
        "repos/owner/repo/pulls/42": { state: "closed", merged: true, merge_commit_sha: commit },
        "repos/owner/repo/releases/latest": undefined,
      }),
    )
  ).status,
  "MERGED",
  "Merged is not the same as released",
);
assert.equal(
  (
    await checkPatch(
      pullPatch,
      api({
        "repos/owner/repo/pulls/42": { state: "closed", merged: false, html_url: "PR URL" },
      }),
    )
  ).status,
  "REVIEW",
  "Closed without merging must not count as a fix",
);

assert.equal(
  (
    await checkPatch(
      { ...patch, kind: "issue", number: 42 },
      api({
        "repos/owner/repo/issues/42": { state: "closed", html_url: "issue URL" },
      }),
    )
  ).status,
  "REVIEW",
  "Issue closure is only a review signal",
);
assert.equal(
  (await checkPatch(patch, api({ "repos/owner/repo/releases/latest": undefined }))).status,
  "UNKNOWN",
);
assert.equal(
  (
    await checkPatch(patch, async () => {
      throw new Error("offline");
    })
  ).status,
  "UNAVAILABLE",
);
assert.equal(
  (
    await checkPatch(
      patch,
      api({
        "repos/owner/repo/releases/latest": release,
        [`repos/owner/repo/compare/${commit}...v2.0.0`]: { status: "unexpected" },
      }),
    )
  ).status,
  "UNAVAILABLE",
  "Malformed API evidence must not masquerade as a negative check",
);

const sourcePatch = {
  ...patch,
  kind: "source",
  source: "extension.js",
  pattern: "pi\\.on\\(\\s*[\"']agent_settled[\"']",
};
for (const [source, expected] of [
  ['pi.on("agent_settled", callback)', "REVIEW"],
  ["pi.on( 'agent_settled', callback)", "REVIEW"],
  ['pi.on("agent_end", callback)', "NOT-FOUND"],
]) {
  const result = await checkPatch(
    sourcePatch,
    api({
      "repos/owner/repo/releases/latest": release,
      "repos/owner/repo/contents/extension.js?ref=v2.0.0": {
        encoding: "base64",
        content: Buffer.from(source).toString("base64"),
      },
    }),
  );
  assert.equal(
    result.status,
    expected,
    "Source markers suggest review, never automatic patch removal",
  );
}

assert.equal(
  (
    await checkPatch({ kind: "manual", reason: "Local preference" }, async () => {
      assert.fail("Manual entries must not query GitHub");
    })
  ).status,
  "MANUAL",
);
const registry = JSON.parse(
  readFileSync(new URL("./upstream-patches.json", import.meta.url), "utf8"),
);
assert.ok(registry.length > 0);
for (const entry of registry) {
  assert.ok(readFileSync(new URL(`../${entry.file}`, import.meta.url), "utf8").length > 0);
  if (entry.kind === "source") new RegExp(entry.pattern);
}
console.log(
  "Upstream release ancestry, PR/issue distinctions, source markers, offline reporting, and registry checks passed",
);
