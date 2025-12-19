require("avante_lib").load()

require("avante").setup({
  -- add any opts here
  -- this file can contain specific instructions for your project
  -- instructions_file = "avante.md",
  -- for example
  provider = "claude",

  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-opus-4-5-20251101",
      timeout = 30000, -- Timeout in milliseconds
      context_window = 200000,
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 64000,
      },
    },
    -- moonshot = {
    --   endpoint = "https://api.moonshot.ai/v1",
    --   model = "kimi-k2-0711-preview",
    --   timeout = 30000, -- Timeout in milliseconds
    --   extra_request_body = {
    --     temperature = 0.75,
    --     max_tokens = 32768,
    --   },
    -- },
  },

  selector = {
    provider = "fzf_lua",
  },

  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,

  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,
})
