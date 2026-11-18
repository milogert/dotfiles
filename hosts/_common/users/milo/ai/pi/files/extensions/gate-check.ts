import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import path from "node:path";

const secretPathPatterns = [
  /(^|[/\\])\.env(\..*)?$/i,
  /(^|[/\\])\.ssh([/\\]|$)/i,
  /(^|[/\\])\.gnupg([/\\]|$)/i,
  /(^|[/\\])id_(rsa|ed25519|ecdsa)(\.pub)?$/i,
  /(^|[/\\])(secrets?|credentials?|tokens?|passwords?)([/\\.]|$)/i,
  /(^|[/\\])(.*secret.*|.*credential.*|.*token.*|.*password.*)$/i,
];

const riskyCommandPatterns: Array<{ pattern: RegExp; reason: string }> = [
  { pattern: /\bsudo\b/i, reason: "uses sudo" },
  { pattern: /\brm\s+(?:-[^\n]*r|--recursive)\b/i, reason: "recursively removes files" },
  { pattern: /\brm\s+(?:-[^\n]*f|--force)\b/i, reason: "force-removes files" },
  { pattern: /\b(git\s+push|git\s+push\b)/i, reason: "pushes git history" },
  { pattern: /\bgit\s+commit\b/i, reason: "creates a git commit" },
  { pattern: /\bterraform\s+(apply|destroy)\b/i, reason: "mutates infrastructure" },
  { pattern: /\btofu\s+(apply|destroy)\b/i, reason: "mutates infrastructure" },
  { pattern: /\b(kubectl|helm)\s+.*\b(apply|delete|upgrade|rollback)\b/i, reason: "mutates cluster state" },
  { pattern: /\b(npm|pnpm|yarn|bun|pip|pipx|cargo|go)\s+.*\b(install|add|remove|update|upgrade)\b/i, reason: "changes dependencies or installed tools" },
  { pattern: /\b(nix\s+profile|nix-env)\b/i, reason: "changes user/global Nix profile" },
  { pattern: /\b(chmod|chown)\b/i, reason: "changes permissions/ownership" },
  { pattern: /\bdeploy\b|\brelease\b/i, reason: "looks like a deploy/release command" },
  { pattern: /\bmix\s+ecto\.(migrate|rollback|reset|drop|create)\b/i, reason: "changes database state" },
];

function normalizeCandidate(cwd: string, candidate: unknown): string | undefined {
  if (typeof candidate !== "string" || candidate.length === 0) return undefined;
  const stripped = candidate.startsWith("@") ? candidate.slice(1) : candidate;
  return path.resolve(cwd, stripped);
}

function isInside(allowedDirectories: string[], parent: string, child: string): boolean {
  if (allowedDirectories.some(dir => child.startsWith(dir))) {
    return true
  }

  const rel = path.relative(parent, child);
  return rel === "" || (!!rel && !rel.startsWith("..") && !path.isAbsolute(rel));
}

function pathLooksSecret(filePath: string): boolean {
  return secretPathPatterns.some((pattern) => pattern.test(filePath));
}

async function confirmOrBlock(ctx: any, title: string, body: string) {
  if (!ctx.hasUI) return { block: true, reason: `${title} blocked: no interactive UI for confirmation` };
  const ok = await ctx.ui.confirm(title, body);
  if (!ok) return { block: true, reason: `${title} blocked by user` };
  return undefined;
}

enum FeaturesEnum {
  editOutsideDirectory = "edit-outside-directory",
  editSecretFile = "edit-secret-file",
  riskyCommand = "risky-command",
  status = "status",
}

export default function (pi: ExtensionAPI) {
  const features = {
    [FeaturesEnum.editOutsideDirectory]: [],
    [FeaturesEnum.editSecretFile]: true,
    [FeaturesEnum.riskyCommand]: true,
  }

  function status(ctx: any) {
    if (!ctx.hasUI) return;
    if (!enabled) ctx.ui.setStatus("gate-check", undefined);
    else ctx.ui.setStatus("gate-check", accepted ? "PLAN accepted" : "PLAN first");
  }

  // pi.on("session_start", (_event, ctx) => {
  //   const last: { data?: { enabled?: boolean; accepted?: boolean } } | undefined =
  //     ctx.sessionManager.getEntries()
  //       .slice()
  //       .reverse()
  //       .find((entry: any) =>
  //         entry.type === "custom" && entry.customType === "plan-mode-lite"
  //       )
  //   enabled = last?.data?.enabled ?? true;
  //   accepted = last?.data?.accepted ?? false;
  //   status(ctx);
  // });

  function persist() {
    pi.appendEntry("gate-check", features);
  }

  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash") {
      if (!features[FeaturesEnum.riskyCommand]) {
        return undefined
      }

      const command = String((event.input as { command?: unknown }).command ?? "");
      const match = riskyCommandPatterns.find(({ pattern }) => pattern.test(command));
      if (!match) {
        return undefined;
      }

      return confirmOrBlock(
        ctx,
        "Risky command",
        `Reason: ${match.reason}\n\nCommand:\n${command}\n\nAllow this command?`,
      );
    }

    if (event.toolName === "write" || event.toolName === "edit") {
      const target = normalizeCandidate(ctx.cwd, (event.input as { path?: unknown }).path);
      if (!target) {
        return undefined;
      }

      if (!isInside(features[FeaturesEnum.editOutsideDirectory], ctx.cwd, target)) {
        return confirmOrBlock(
          ctx,
          "Write outside working directory",
          `Tool: ${event.toolName}\nTarget: ${target}\nWorking directory: ${ctx.cwd}\n\nAllow this write?`,
        );
      }

      if (features[FeaturesEnum.editSecretFile] && pathLooksSecret(target)) {
        return confirmOrBlock(
          ctx,
          "Possible secret file write",
          `Tool: ${event.toolName}\nTarget: ${target}\n\nThis path looks like it may contain secrets or credentials. Allow this write?`,
        );
      }
    }

    return undefined;
  });

  pi.on("user_bash", async (event, ctx) => {
    if (!features[FeaturesEnum.riskyCommand]) {
      return undefined
    }

    const match = riskyCommandPatterns.find(({ pattern }) => pattern.test(event.command));
    if (!match) return undefined;

    if (!ctx.hasUI) {
      return {
        result: {
          output: `Blocked risky command (${match.reason}): no interactive UI for confirmation`,
          exitCode: 1,
          cancelled: false,
          truncated: false,
        },
      };
    }

    const ok = await ctx.ui.confirm(
      "Risky shell command",
      `Reason: ${match.reason}\n\nCommand:\n${event.command}\n\nAllow this command?`,
    );

    if (!ok) {
      return {
        result: {
          output: "Blocked by gate-check",
          exitCode: 1,
          cancelled: false,
          truncated: false,
        },
      };
    }

    return undefined;
  });

  pi.registerCommand("gate-check", {
    description: `Manage the safety gate features:
/gate-check
  (edit-outside-directory|edit-secret-file|risky-command) [on|off|TOGGLE]
    Changes one of the settings. If you omit the second argument it toggles the setting.

  edit-outside-directory (add|remove|reset) directory1 directory2 ...
    Adds or removes the list of directories. If you call \`reset\` it removes all directories from the array.

  status
    Displays the status`,
    handler: async (args, ctx) => {
      const [command, subcommand, ...subcommandArgs] = args.trim().split(' ', 3)

      if (command === FeaturesEnum.status) {
        ctx.ui.notify(Object.keys(features).map((feature) => {
          return `${feature} -> ${features[feature] ? 'enabled' : 'disabled'}`
        }).join('\n'))
        return
      }

      if (command === status) {
        ctx.ui.notify(JSON.stringify(features), 'info')
        return
      }

      if (command === FeaturesEnum.editOutsideDirectory) {
        if (subcommand === 'add') {
          features[FeaturesEnum.editOutsideDirectory] = [...new Set([...subcommandArgs, features[FeaturesEnum.editOutsideDirectory]])]
        } else if (subcommand === 'remove') {
          features[FeaturesEnum.editOutsideDirectory] = features[FeaturesEnum.editOutsideDirectory].filter(dir => !subcommandArgs.includes(dir))
        } else if (subcommand === 'reset') {
          features[FeaturesEnum.editOutsideDirectory] = []
        } else {
          ctx.ui.notify("/gate-check edit-outside-directory (add|remove) directory1 directory2 ...")
        }
        return
      }

      const isCommand = [FeaturesEnum.editSecretFile, FeaturesEnum.riskyCommand].includes(command)

      if (!isCommand) {
        ctx.ui.notify("/gate-check edit-outside-directory|edit-secret-file|risky-command on|off|toggle")
        return
      }

      if (subcommand) {
        switch (subcommand) {
          case 'on':
            features[command] = true
            break

          case 'off':
            features[command] = false
            break

          case 'toggle':
            features[command] = !features[command]
            break

          default:
            ctx.ui.notify(`${subcommand} is not one of on|off|toggle`, "info")
            return
        }
      } else {
        features[command] = !features[command]
      }

      ctx.ui.notify(`${command} set to ${features[command]}`, "info")
    },

    getArgumentCompletions: (prefix) => {
      const [command, subcommand] = prefix.trimStart().split(' ', 2)

      let matches

      if (subcommand === undefined) {
        matches = [FeaturesEnum.editOutsideDirectory, FeaturesEnum.editSecretFile, FeaturesEnum.riskyCommand]
          .filter((value) => value.startsWith(command.toLowerCase().trim()))
          .map((value) => ({ value: `${value} `, label: value }));

        if (matches.length) {
          return matches
        }
      }

      matches = ['on', 'off', 'toggle']
        .filter((value) => value.startsWith((subcommand || '').toLowerCase().trim()))
        .map((value) => ({ value: `${command} ${value} `, label: value }));

      if (matches.length) {
        return matches
      }

      return null
    },

  })
}
