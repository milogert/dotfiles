import { execFile } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";

const execute = promisify(execFile);
const repositoryRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");

async function github(endpoint) {
  try {
    const { stdout } = await execute(
      "gh",
      ["api", "--hostname", "github.com", "--method", "GET", endpoint],
      { timeout: 10000, maxBuffer: 2 * 1024 * 1024 },
    );
    return JSON.parse(stdout);
  } catch (error) {
    // A repository without GitHub releases returns 404, not an empty release.
    if (error.stdout) {
      try {
        if (JSON.parse(error.stdout).status === "404") return undefined;
      } catch {
        // Non-JSON command failures are reported below, never as "not fixed".
      }
    }
    throw new Error(
      error.killed ? "GitHub check timed out" : error.stderr?.trim() || error.message,
    );
  }
}

export async function checkPatch(patch, api = github) {
  if (patch.kind === "manual") return { status: "MANUAL", detail: patch.reason };

  try {
    let commit = patch.commit;

    if (patch.kind === "issue") {
      const issue = await api(`repos/${patch.repo}/issues/${patch.number}`);
      if (!issue || !["open", "closed"].includes(issue.state))
        throw new Error("Tracked issue could not be read");
      return {
        status: issue.state === "closed" ? "REVIEW" : "OPEN",
        detail: `${issue.html_url}: ${issue.state}; issue closure alone does not prove a released fix`,
      };
    }

    if (patch.kind === "pull") {
      const pull = await api(`repos/${patch.repo}/pulls/${patch.number}`);
      if (!pull || typeof pull.merged !== "boolean" || !["open", "closed"].includes(pull.state))
        throw new Error("Tracked PR could not be read");
      if (!pull.merged) {
        return {
          status: pull.state === "open" ? "OPEN" : "REVIEW",
          detail: `${pull.html_url}: ${pull.state}, not merged`,
        };
      }
      commit = pull.merge_commit_sha;
      if (!commit) throw new Error("Merged PR has no merge commit");
    }

    const release = await api(`repos/${patch.repo}/releases/latest`);
    if (!release) {
      return {
        status: patch.kind === "pull" ? "MERGED" : "UNKNOWN",
        detail: "No GitHub release found; no claim that the workaround can be removed",
      };
    }
    if (!release.tag_name) throw new Error("Release has no tag");
    const tag = encodeURIComponent(release.tag_name);

    if (patch.kind === "source") {
      const source = await api(`repos/${patch.repo}/contents/${patch.source}?ref=${tag}`);
      if (!source || source.encoding !== "base64")
        throw new Error("Released source could not be read");
      const matches = new RegExp(patch.pattern).test(
        Buffer.from(source.content, "base64").toString("utf8"),
      );
      return {
        status: matches ? "REVIEW" : "NOT-FOUND",
        detail: matches
          ? `${release.html_url}: released source matches the fix marker; verify behavior before removing the patch`
          : `${release.tag_name}: expected fix marker absent from released source`,
      };
    }

    const comparison = await api(`repos/${patch.repo}/compare/${commit}...${tag}`);
    if (!comparison || !["ahead", "identical", "behind", "diverged"].includes(comparison.status))
      throw new Error("Fix ancestry could not be checked");
    const included = ["ahead", "identical"].includes(comparison.status);
    return {
      status: included ? "RELEASED" : "NOT-RELEASED",
      detail: included
        ? `${release.html_url}: release contains fix ${commit}; review ${patch.file}`
        : `${release.tag_name} does not contain fix ${commit}`,
    };
  } catch (error) {
    return { status: "UNAVAILABLE", detail: error.message };
  }
}

export async function main() {
  const patches = JSON.parse(
    readFileSync(resolve(repositoryRoot, "scripts/upstream-patches.json"), "utf8"),
  );
  if (!Array.isArray(patches)) throw new Error("Patch registry must be an array");

  for (const patch of patches) {
    if (
      !patch.name ||
      !patch.file ||
      !["manual", "issue", "pull", "source", "commit"].includes(patch.kind)
    ) {
      throw new Error("Patch registry entry has an invalid name, file, or kind");
    }
    if (patch.kind !== "manual" && !/^[\w.-]+\/[\w.-]+$/.test(patch.repo ?? "")) {
      throw new Error(`Invalid GitHub repository for ${patch.name}`);
    }
    if (patch.kind === "commit" && !/^[a-f0-9]{40}$/.test(patch.commit ?? "")) {
      throw new Error(`Invalid fix commit for ${patch.name}`);
    }
  }

  console.log("-- Upstream workaround audit (advisory; never updates or removes patches) --");
  const results = await Promise.all(
    patches.map(async (patch) => {
      if (!existsSync(resolve(repositoryRoot, patch.file))) return undefined;
      return { patch, ...(await checkPatch(patch)) };
    }),
  );

  for (const result of results) {
    if (!result) continue;
    console.log(`[${result.status}] ${result.patch.name}: ${result.detail}`);
  }
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main().catch((error) => {
    console.error(`Upstream patch check failed: ${error.message}`);
    process.exitCode = 1;
  });
}
