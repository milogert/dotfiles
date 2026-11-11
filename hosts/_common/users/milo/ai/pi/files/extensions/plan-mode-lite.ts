import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

enum SUBCOMMANDS {
  execute = 'execute',
  accept = 'accept',
  reset = 'reset',
  status = 'status',
  on = 'on',
  off = 'off',
}

export default function (pi: ExtensionAPI) {
  let enabled = true;
  let accepted = false;

  function status(ctx: any) {
    if (!ctx.hasUI) return;
    if (!enabled) ctx.ui.setStatus("plan-mode", undefined);
    else ctx.ui.setStatus("plan-mode", accepted ? "PLAN accepted" : "PLAN first");
  }

  pi.on("session_start", (_event, ctx) => {
    const last: { data?: { enabled?: boolean; accepted?: boolean } } | undefined =
      ctx.sessionManager.getEntries()
        .slice()
        .reverse()
        .find((entry: any) =>
          entry.type === "custom" && entry.customType === "plan-mode-lite"
        )
    enabled = last?.data?.enabled ?? true;
    accepted = last?.data?.accepted ?? false;
    status(ctx);
  });

  function persist() {
    pi.appendEntry("plan-mode-lite", { enabled, accepted });
  }

  pi.registerCommand("planmode", {
    description: "Planning-first guardrails: /planmode on|off|accept|execute|reset|status",
    handler: async (args, ctx) => {
      const action = (args.trim() || SUBCOMMANDS.status).toLowerCase();

      if (action === SUBCOMMANDS.on) {
        enabled = true;
        accepted = false;
        persist();
        status(ctx);
        ctx.ui.notify("Plan mode enabled. Use /planmode execute after approving a plan.", "info");
        return;
      }

      if (action === SUBCOMMANDS.off) {
        enabled = false;
        accepted = false;
        persist();
        status(ctx);
        ctx.ui.notify("Plan mode disabled.", "info");
        return;
      }

      if (action === SUBCOMMANDS.accept || action === SUBCOMMANDS.execute) {
        if (!ctx.isIdle()) {
          ctx.ui.notify("Wait for the agent to finish before accepting the plan.", "warning");
          return;
        }

        enabled = true;
        accepted = true;
        persist();
        status(ctx);
        // Dispatch the installed auto-mode extension's public command, not its internal state.
        // pi.sendUserMessage("/automode on", { expandPromptTemplates: true });
        if (action === SUBCOMMANDS.execute) {
          pi.sendUserMessage("Execute the accepted plan now. Keep changes focused and verify them.", {
            deliverAs: "followUp",
          });
        } else {
          ctx.ui.notify("Plan accepted. Auto mode enabled; send a prompt when ready to implement.", "success");
        }
        return;
      }

      if (action === SUBCOMMANDS.reset) {
        enabled = true;
        accepted = false;
        persist();
        status(ctx);
        ctx.ui.notify("Plan reset. Use /planmode execute after approving a plan.", "info");
        return;
      }

      ctx.ui.notify(
        enabled
          ? accepted
            ? "Plan mode is on; current plan accepted. Use /planmode reset to require a new plan."
            : "Plan mode is on; writes blocked. Use /planmode execute to approve and start implementation."
          : "Plan mode is off. Use /planmode on to enable.",
        "info",
      );
    },

    getArgumentCompletions: (prefix) => {
      const matches = [SUBCOMMANDS.execute, SUBCOMMANDS.accept]
        .filter((value) => value.startsWith(prefix))
        .map((value) => ({ value, label: value }));
      return matches.length ? matches : null;
    },

  });

  pi.on("before_agent_start", (event) => {
    if (!enabled) {
      return undefined;
    }

    const guardrail = accepted
      ? "Planning-first mode is enabled and the current plan has been accepted. Implement according to the accepted plan, keeping changes focused. If new risk or scope appears, stop and ask before continuing."
      : "Planning-first mode is enabled and no plan has been accepted yet. Inspect and produce a concise plan. Do not write/edit files or intentionally mutate project state. Ask the user to approve with `/planmode execute` to start implementation (or `/planmode accept` to approve without starting).";

    return {
      systemPrompt: `${event.systemPrompt}\n\n${guardrail}`,
    };
  });

  pi.on("tool_call", (event) => {
    if (!enabled || accepted) {
      return undefined;
    }

    if (event.toolName !== "write" && event.toolName !== "edit") {
      return undefined;
    }

    return {
      block: true,
      reason: "Plan mode is enabled. Get user approval and run /planmode execute (or /planmode accept) before writing files.",
    };
  });
}
