import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

// Decision/usage telemetry, not a promise that the provider still has the cache.
export default function cacheStatus(pi: ExtensionAPI) {
  let decision: "warm" | "stop" | undefined;
  let decisionAt = 0;
  let timer: ReturnType<typeof setInterval> | undefined;

  function render(ctx: ExtensionContext) {
    const mode = pi.getSettings().cacheWarming ?? "idle";
    let status = `cache: ${mode}`;
    if (mode !== "off") {
      const lastRefresh = ctx.sessionManager.getBranch().findLast(
        entry => entry.type === "usage" && entry.kind === "cache_warm",
      );
      const refreshedAt = lastRefresh ? Date.parse(lastRefresh.timestamp) : 0;
      if (refreshedAt > decisionAt) {
        status += ` | refreshed ${Math.max(0, Math.floor((Date.now() - refreshedAt) / 60000))}m ago`;
      } else if (decision) {
        status += decision === "warm" ? " | refresh requested" : " | stopped";
      } else {
        status += " | awaiting decision";
      }
    }
    ctx.ui.setStatus("cache-warming", status);
  }

  pi.on("session_start", (_event, ctx) => {
    decision = undefined;
    decisionAt = 0;
    if (timer) clearInterval(timer);
    render(ctx);
    if (ctx.hasUI) timer = setInterval(() => render(ctx), 5000);
  });
  pi.on("cache_warming_decision", (event, ctx) => {
    decision = event.action;
    decisionAt = Date.now();
    render(ctx);
    // Observe only: do not override Pi's policy.
  });
  pi.on("agent_start", (_event, ctx) => {
    decision = undefined;
    decisionAt = Date.now();
    render(ctx);
  });
  pi.on("model_select", (_event, ctx) => {
    decision = undefined;
    decisionAt = Date.now();
    render(ctx);
  });
  pi.on("session_shutdown", (_event, ctx) => {
    if (timer) clearInterval(timer);
    timer = undefined;
    ctx.ui.setStatus("cache-warming", undefined);
  });
}
