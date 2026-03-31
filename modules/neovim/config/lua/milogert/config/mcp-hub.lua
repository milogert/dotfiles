require("mcphub").setup({
  cmd = "node",
  cmdArgs = {
    "node_modules/mcp-hub/dist/cli.js",
  },
  -- use_bundled_binary = true,
  port = 37373,

  workspace = {
    enabled = true, -- Enable project-local configuration files
    look_for = {
      ".mcp.json",
      ".mcphub/servers.json",
      ".vscode/mcp.json",
      ".cursor/mcp.json",
    }, -- Files to look for when detecting project boundaries (VS Code format supported)
    reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
    -- port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
    -- get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
  },
})
