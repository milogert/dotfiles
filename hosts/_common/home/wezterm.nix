{ pkgs, config, ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
      --function log_proc(proc, indent)
      --  indent = indent or ""
      --  wezterm.log_info(
      --    indent
      --      .. "pid="
      --      .. proc.pid
      --      .. ", name="
      --      .. proc.name
      --      .. ", status="
      --      .. proc.status
      --  )
      --  wezterm.log_info(indent .. "argv=" .. table.concat(proc.argv, " "))
      --  wezterm.log_info(
      --    indent .. "executable=" .. proc.executable .. ", cwd=" .. proc.cwd
      --  )
      --  for pid, child in pairs(proc.children) do
      --    log_proc(child, indent .. "  ")
      --  end
      --end
      --
      --wezterm.on("mux-is-process-stateful", function(proc)
      --  log_proc(proc)
      --
      --  -- Just use the default behavior
      --  return nil
      --end)

      return {
        -- Workaround for https://github.com/NixOS/nixpkgs/issues/336069
        front_end = "WebGpu",
        -- I might need this on linux, but not Darwin
        -- enable_wayland = false,

        color_scheme = "Srcery (Gogh)",
        font = wezterm.font("Hack"),
        font_size = 11.0,
        hide_tab_bar_if_only_one_tab = true,
        window_close_confirmation = 'NeverPrompt',

        keys = {
          {
            key = 'w',
            mods = 'CMD',
            action = wezterm.action.CloseCurrentTab { confirm = false },
          },
        },
      }'';
  };
}
