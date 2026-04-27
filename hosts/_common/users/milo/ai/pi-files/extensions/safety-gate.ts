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

function isInside(parent: string, child: string): boolean {
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

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash") {
      const command = String((event.input as { command?: unknown }).command ?? "");
      const match = riskyCommandPatterns.find(({ pattern }) => pattern.test(command));
      if (!match) return undefined;

      return confirmOrBlock(
        ctx,
        "Risky command",
        `Reason: ${match.reason}\n\nCommand:\n${command}\n\nAllow this command?`,
      );
    }

    if (event.toolName === "write" || event.toolName === "edit") {
      const target = normalizeCandidate(ctx.cwd, (event.input as { path?: unknown }).path);
      if (!target) return undefined;

      if (!isInside(ctx.cwd, target)) {
        return confirmOrBlock(
          ctx,
          "Write outside working directory",
          `Tool: ${event.toolName}\nTarget: ${target}\nWorking directory: ${ctx.cwd}\n\nAllow this write?`,
        );
      }

      if (pathLooksSecret(target)) {
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
          output: "Blocked by safety-gate",
          exitCode: 1,
          cancelled: false,
          truncated: false,
        },
      };
    }

    return undefined;
  });
}
