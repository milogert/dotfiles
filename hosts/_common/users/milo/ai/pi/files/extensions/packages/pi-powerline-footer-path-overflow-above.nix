{ pkgs, src }:

pkgs.runCommand "pi-powerline-footer-overflow-above" { } ''
  cp -R ${src} $out
  chmod u+w $out/index.ts
  substituteInPlace $out/index.ts \
    --replace-fail '    if (editorPerf.options.bashWidgets) {' '
      ctx.ui.setWidget("powerline-secondary", (_tui: any, theme: Theme) => ({
        dispose() {},
        invalidate() {
          resetLayoutCache();
        },
        render(width: number): string[] {
          return measureWidget("secondary", () => renderPowerlineSecondaryLines(width, theme));
        },
      }), { placement: "aboveEditor" });

      if (editorPerf.options.bashWidgets) {' \
    --replace-fail '          return renderPowerlineSecondaryLines(width, theme);' '          return [];'
''
