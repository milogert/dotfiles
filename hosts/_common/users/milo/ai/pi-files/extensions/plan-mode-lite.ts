import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let enabled = true;
  let accepted = false;

  function status(ctx: any) {
    if (!ctx.hasUI) return;
    if (!enabled) ctx.ui.setStatus("plan-mode", undefined);
    else ctx.ui.setStatus("plan-mode", accepted ? "PLAN accepted" : "PLAN first");
  }

  pi.on("session_start", (_event, ctx) => status(ctx));

  pi.registerCommand("planmode", {
    description: "Toggle planning-first guardrails: /planmode on|off|accept|reset|status",
    handler: async (args, ctx) => {
      const action = (args.trim() || "status").toLowerCase();

      if (action === "on") {
        enabled = true;
        accepted = false;
        status(ctx);
        ctx.ui.notify("Plan mode enabled. Writes are blocked until /planmode accept.", "info");
        return;
      }

      if (action === "off") {
        enabled = false;
        accepted = false;
        status(ctx);
        ctx.ui.notify("Plan mode disabled.", "info");
        return;
      }

      if (action === "accept") {
        enabled = true;
        accepted = true;
        status(ctx);
        ctx.ui.notify("Plan accepted. Writes are allowed.", "success");
        return;
      }

      if (action === "reset") {
        enabled = true;
        accepted = false;
        status(ctx);
        ctx.ui.notify("Plan reset. Writes are blocked until /planmode accept.", "info");
        return;
      }

      ctx.ui.notify(
        enabled
          ? accepted
            ? "Plan mode is on; current plan accepted. Use /planmode reset to require a new plan."
            : "Plan mode is on; writes blocked. Use /planmode accept after approving the plan."
          : "Plan mode is off. Use /planmode on to enable.",
        "info",
      );
    },
  });

  pi.on("before_agent_start", (event) => {
    if (!enabled) return undefined;

    const guardrail = accepted
      ? "Planning-first mode is enabled and the current plan has been accepted. Implement according to the accepted plan, keeping changes focused. If new risk or scope appears, stop and ask before continuing."
      : "Planning-first mode is enabled and no plan has been accepted yet. Inspect and produce a concise plan. Do not write/edit files or intentionally mutate project state. Ask the user to approve with `/planmode accept` before implementation.";

    return {
      systemPrompt: `${event.systemPrompt}\n\n${guardrail}`,
    };
  });

  pi.on("tool_call", (event) => {
    if (!enabled || accepted) return undefined;
    if (event.toolName !== "write" && event.toolName !== "edit") return undefined;

    return {
      block: true,
      reason: "Plan mode is enabled. Get user approval and run /planmode accept before writing files.",
    };
  });
}
