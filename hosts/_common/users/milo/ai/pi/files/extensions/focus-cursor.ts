import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { CURSOR_MARKER } from "@earendil-works/pi-tui";

// Pi draws a reverse-video cursor over the hardware cursor; keep only the latter.
const fakeCursor = new RegExp(`${CURSOR_MARKER}\\x1b\\[7m(.*?)\\x1b\\[0m`, "g");

class HardwareCursorEditor extends CustomEditor {
  render(width: number): string[] {
    return super.render(width).map((line) => line.replace(fakeCursor, `${CURSOR_MARKER}$1`));
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;
    ctx.ui.setEditorComponent((tui, theme, keybindings) =>
      new HardwareCursorEditor(tui, theme, keybindings),
    );
  });
}
