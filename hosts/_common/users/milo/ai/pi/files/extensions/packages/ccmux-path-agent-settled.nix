{
  pkgs,
  source,
  homeDirectory,
  version,
}:

# Upstream 1.4.6/main still marks idle on agent_end, before retries/queued runs settle.
pkgs.runCommand "ccmux-pi-extension.js" { } ''
  substitute ${source} $out \
    --replace-fail '"__CCMUX_MARKERS_DIR__"' ${pkgs.lib.escapeShellArg (builtins.toJSON "${homeDirectory}/.config/ccmux/session-pids")} \
    --replace-fail '__CCMUX_VERSION__' '${version}' \
    --replace-fail 'agent_start / agent_end' 'agent_start / agent_settled' \
    --replace-fail '"agent_end"' '"agent_settled"'
''
