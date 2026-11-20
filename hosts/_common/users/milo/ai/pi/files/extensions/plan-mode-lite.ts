import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

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

  function status(ctx: ExtensionContext) {
    if (!ctx.hasUI) return;
    if (!enabled) ctx.ui.setStatus("plan-mode", undefined);
    else ctx.ui.setStatus("plan-mode", accepted ? "PLAN accepted" : "PLAN first");
  }

  function restore(ctx: ExtensionContext) {
    const last = ctx.sessionManager.getBranch().findLast((entry) =>
      entry.type === "custom" && entry.customType === "plan-mode-lite"
    );
    const stored = last?.type === "custom"
      ? last.data as { enabled?: boolean; accepted?: boolean } | undefined
      : undefined;
    enabled = typeof stored?.enabled === "boolean" ? stored.enabled : true;
    accepted = enabled && stored?.accepted === true;
    status(ctx);
  }

  pi.on("session_start", (_event, ctx) => restore(ctx));
  pi.on("session_tree", (_event, ctx) => restore(ctx));

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
        if (action === SUBCOMMANDS.execute) {
          pi.sendUserMessage("Execute the accepted plan now. Keep changes focused and verify them.", {
            deliverAs: "followUp",
          });
        } else {
          ctx.ui.notify("Plan accepted. Send a prompt when ready to implement; use /planmode reset for a new task.", "info");
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
            : "Plan mode is on; edit/write tools blocked (not a shell sandbox). Use /planmode execute to approve and start implementation."
          : "Plan mode is off. Use /planmode on to enable.",
        "info",
      );
    },

    getArgumentCompletions: (prefix) => {
      const matches = Object.values(SUBCOMMANDS)
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
      : "Planning-first mode is enabled and no plan has been accepted yet. Inspect and produce a concise plan. Do not write/edit files or intentionally mutate project state. Do not use `ask_user` or an approval picker for plan approval: picker answers do not run slash commands or unlock implementation. Use `ask_user` for requirements questions, not to ask whether to execute the plan. End your response by telling the user to run `/planmode execute` to approve and start implementation (or `/planmode accept` to approve without starting), then wait for that command.";

    event.systemPromptOptions.sections["plan-mode"] = guardrail;
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
