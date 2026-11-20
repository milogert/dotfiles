/**
 * Describes the command runner used by Git snapshot helpers.
 */
export type Execute = (command: string, args: string[], optional?: boolean) => Promise<string>;

/**
 * Captures the Git remote ref and commit information used to find a PR.
 */
export type Push = {
  branch: string;
  ref: string;
  repository: string;
  head: string;
  sha: string;
  token: string;
  pushedAt: number;
};

const GITHUB_REPO_REGEX =
  /^(?:git@github\.com:|https:\/\/github\.com\/|ssh:\/\/git@github\.com\/)([\w.-]+\/[\w.-]+?)(?:\.git)?$/;

/**
 * Extracts the owner/repository name from a supported GitHub remote URL.
 */
export function githubRepository(remote: string): string | undefined {
  return GITHUB_REPO_REGEX.exec(remote.trim())?.[1];
}

const TIMESTAMP_REGEX = /@\{(\d+) [+-]\d+\}$/;

/**
 * Finds the newest push event in a remote-tracking ref's reflog.
 */
export function pushedReflog(
  reflog: string,
): { token: string; sha: string; pushedAt: number } | undefined {
  for (const line of reflog.trim().split("\n")) {
    const [selector, sha, message] = line.split("\t");
    const timestamp = TIMESTAMP_REGEX.exec(selector)?.[1];

    if (message === "update by push" && timestamp && /^[a-f0-9]{40,64}$/.test(sha)) {
      return { token: `${selector}:${sha}`, sha, pushedAt: Number(timestamp) * 1000 };
    }
  }
}

const REFS_REGEX = /^refs\/remotes\/([^/]+)\/(.+)$/;

/**
 * Reads the current branch, HEAD, push target, and latest recorded push.
 */
export async function snapshot(
  execute: Execute,
): Promise<{ branch: string; localSha: string; push?: Push }> {
  const branch = await execute("git", ["symbolic-ref", "--quiet", "--short", "HEAD"], true);

  if (!branch) {
    return { branch: "", localSha: "" };
  }

  const localSha = await execute("git", ["rev-parse", "HEAD"]);
  const refs = (
    await execute("git", ["for-each-ref", "--format=%(push)\t%(upstream)", `refs/heads/${branch}`])
  ).split("\t");
  const ref = refs[0] || refs[1] || `refs/remotes/origin/${branch}`;
  const match = REFS_REGEX.exec(ref);

  if (!match) {
    return { branch, localSha };
  }

  const repository = githubRepository(
    await execute("git", ["remote", "get-url", "--push", match[1]], true),
  );

  if (!repository) {
    return { branch, localSha };
  }

  const pushed = pushedReflog(
    await execute(
      "git",
      ["reflog", "show", "--date=raw", "--format=%gD%x09%H%x09%gs", "-n", "20", ref],
      true,
    ),
  );

  return {
    branch,
    localSha,
    push: {
      ...(pushed ?? { token: ref, sha: localSha, pushedAt: Date.now() }),
      branch,
      ref,
      repository,
      head: match[2],
    },
  };
}
