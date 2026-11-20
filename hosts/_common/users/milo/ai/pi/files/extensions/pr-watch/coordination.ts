import { createHash, randomUUID } from "node:crypto";
import { mkdirSync, readFileSync, renameSync, rmdirSync, unlinkSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import type { Push } from "./git.ts";

// Coordinates PR-watch ownership and shared state for one checkout.

type Member = {
  pid: number;
};

export type Watch = Push & {
  owner?: string;
  lastPoll: number;
  number?: number;
  base?: string;
  pullState?: string;
  feedbackBaselineRecorded?: boolean;
  seen: string[];
};

type State = {
  members: Record<string, Member>;
  owner?: string;
  watch?: Watch;
};

/** Returns whether the operating system reports that the process is alive. */
function processIsAlive(pid: number): boolean {
  if (!Number.isSafeInteger(pid) || pid <= 0) {
    throw new Error("Invalid PR watch PID");
  }

  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ESRCH") {
      return false;
    }
    if ((error as NodeJS.ErrnoException).code === "EPERM") {
      return true;
    }
    throw error;
  }
}

/** Serializes state updates for a checkout with a short-lived filesystem lock. */
export class Coordinator {
  private directory: string;

  /** Creates the private state directory for the canonical checkout path. */
  constructor(stateDirectory: string, checkout: string) {
    this.directory = join(stateDirectory, createHash("sha256").update(checkout).digest("hex"));
    mkdirSync(this.directory, { recursive: true, mode: 0o700 });
  }

  /** Applies and persists a mutation, or returns undefined when another process holds the lock. */
  update<T>(mutate: (state: State) => T): T | undefined {
    const lock = join(this.directory, "lock");
    const temporaryLock = join(this.directory, `${process.pid}-${randomUUID()}.lock`);
    mkdirSync(temporaryLock, { mode: 0o700 });
    writeFileSync(join(temporaryLock, "pid"), String(process.pid), { mode: 0o600 });
    let acquired = false;

    try {
      try {
        // POSIX rename cannot replace a nonempty directory. Publish the PID with the lock.
        renameSync(temporaryLock, lock);
        acquired = true;
      } catch (error) {
        if (!["EEXIST", "ENOTEMPTY"].includes((error as NodeJS.ErrnoException).code ?? "")) {
          throw error;
        }

        // A crash during serialized stale-lock cleanup needs manual recovery-dir cleanup;
        // use an OS advisory-lock dependency if automatic recovery from that window is required.
        const recovery = join(this.directory, "recovery");
        try {
          mkdirSync(recovery, { mode: 0o700 });
        } catch (recoveryError) {
          if ((recoveryError as NodeJS.ErrnoException).code === "EEXIST") {
            return;
          }
          throw recoveryError;
        }
        try {
          const ownerPid = Number(readFileSync(join(lock, "pid"), "utf8"));
          if (!processIsAlive(ownerPid)) {
            const abandoned = join(recovery, "lock");
            renameSync(lock, abandoned);
            unlinkSync(join(abandoned, "pid"));
            rmdirSync(abandoned);
          }
        } catch (cleanupError) {
          if ((cleanupError as NodeJS.ErrnoException).code !== "ENOENT") {
            throw cleanupError;
          }
        } finally {
          rmdirSync(recovery);
        }
        return;
      }

      const file = join(this.directory, "state.json");
      let state: State = { members: {} };

      try {
        state = JSON.parse(readFileSync(file, "utf8"));
      } catch (error) {
        if ((error as NodeJS.ErrnoException).code !== "ENOENT") {
          throw error;
        }
      }

      const result = mutate(state);
      const temporary = join(this.directory, `${process.pid}.tmp`);
      writeFileSync(temporary, JSON.stringify(state), { mode: 0o600 });
      renameSync(temporary, file);

      return result;
    } finally {
      if (acquired) {
        renameSync(lock, temporaryLock);
      }
      unlinkSync(join(temporaryLock, "pid"));
      rmdirSync(temporaryLock);
    }
  }
}

/** Prunes dead sessions, assigns checkout ownership, and updates the owner's PR watch. */
export function selectWatch(
  state: State,
  memberId: string,
  member: Member,
  push?: Push,
): Watch | undefined {
  for (const [id, candidate] of Object.entries(state.members)) {
    if (!processIsAlive(candidate.pid)) {
      delete state.members[id];
    }
  }

  // With no surviving sessions, discover the new session's PR rather than a historical one.
  if (!Object.keys(state.members).length) {
    delete state.watch;
  }
  state.members[memberId] = member;

  if (!state.owner || !state.members[state.owner]) {
    state.owner = memberId;
    if (state.watch) {
      state.watch.owner = memberId;
      state.watch.lastPoll = 0;
    }
  }

  if (state.owner !== memberId) {
    return;
  }

  if (
    push &&
    (!state.watch?.number ||
      (state.watch.branch === push.branch &&
        state.watch.repository === push.repository &&
        state.watch.head === push.head)) &&
    state.watch?.token !== push.token
  ) {
    state.watch = {
      ...state.watch,
      ...push,
      owner: memberId,
      pushedAt: state.watch?.pushedAt ?? push.pushedAt,
      lastPoll: 0,
      seen: state.watch?.seen ?? [],
    };
  }

  return state.watch ? structuredClone(state.watch) : undefined;
}
