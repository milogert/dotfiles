require("mcphub").setup({
  cmd = "node",
  cmdArgs = { "node_modules/.bin/mcp-hub" },
  port = 37373,

  extensions = {
    avante = {
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
  },
})
