require("avante_lib").load()

require("avante").setup({
  -- add any opts here
  -- this file can contain specific instructions for your project
  -- instructions_file = "avante.md",
  -- for example
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  ---@type Provider
  provider = "claude",

  providers = {
    claude = {
      -- auth_type = "max",
      endpoint = "https://api.anthropic.com",
      model = "claude-opus-4-6",
      -- This violates their ToS.
      -- auth_type = "max", -- Set to "max" to sign in with Claude Pro/Max subscription
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

  ---@alias Mode "agentic" | "legacy"
  ---@type Mode
  -- mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.

  -- -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
  -- -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
  -- -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
  -- auto_suggestions_provider = "claude",

  -- ---Specify the special dual_boost mode
  -- ---1. enabled: Whether to enable dual_boost mode. Default to false.
  -- ---2. first_provider: The first provider to generate response. Default to "openai".
  -- ---3. second_provider: The second provider to generate response. Default to "claude".
  -- ---4. prompt: The prompt to generate response based on the two reference outputs.
  -- ---5. timeout: Timeout in milliseconds. Default to 60000.
  -- ---How it works:
  -- --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
  -- ---Note: This is an experimental feature and may not work as expected.
  -- dual_boost = {
  --   enabled = false,
  --   first_provider = "openai",
  --   second_provider = "claude",
  --   prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
  --   timeout = 60000, -- Timeout in milliseconds
  -- },

  -- behaviour = {
  --   auto_suggestions = false, -- Experimental stage
  --   auto_set_highlight_group = true,
  --   auto_set_keymaps = true,
  --   auto_apply_diff_after_generation = false,
  --   support_paste_from_clipboard = false,
  --   minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
  --   enable_token_counting = true, -- Whether to enable token counting. Default to true.
  --   auto_add_current_file = true, -- Whether to automatically add the current file when opening a new chat. Default to true.
  --   auto_approve_tool_permissions = true, -- Default: auto-approve all tools (no prompts)
  --   -- Examples:
  --   -- auto_approve_tool_permissions = false,                -- Show permission prompts for all tools
  --   -- auto_approve_tool_permissions = {"bash", "str_replace"}, -- Auto-approve specific tools only
  --   ---@type "popup" | "inline_buttons"
  --   confirmation_ui_style = "inline_buttons",
  --   --- Whether to automatically open files and navigate to lines when ACP agent makes edits
  --   ---@type boolean
  --   acp_follow_agent_locations = true,
  -- },

  -- prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
  --   enabled = true, -- toggle logging entirely
  --   log_dir = vim.fn.stdpath("cache") .. "/avante_prompts", -- directory where logs are saved
  --   fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
  --   next_prompt = {
  --     normal = "<C-n>", -- load the next (newer) prompt log in normal mode
  --     insert = "<C-n>",
  --   },
  --   prev_prompt = {
  --     normal = "<C-p>", -- load the previous (older) prompt log in normal mode
  --     insert = "<C-p>",
  --   },
  -- },

  -- mappings = {
  --   --- @class AvanteConflictMappings
  --   diff = {
  --     ours = "co",
  --     theirs = "ct",
  --     all_theirs = "ca",
  --     both = "cb",
  --     cursor = "cc",
  --     next = "]x",
  --     prev = "[x",
  --   },
  --   suggestion = {
  --     accept = "<M-l>",
  --     next = "<M-]>",
  --     prev = "<M-[>",
  --     dismiss = "<C-]>",
  --   },
  --   jump = {
  --     next = "]]",
  --     prev = "[[",
  --   },
  --   submit = {
  --     normal = "<CR>",
  --     insert = "<C-s>",
  --   },
  --   cancel = {
  --     normal = { "<C-c>", "<Esc>", "q" },
  --     insert = { "<C-c>" },
  --   },
  --   sidebar = {
  --     apply_all = "A",
  --     apply_cursor = "a",
  --     retry_user_request = "r",
  --     edit_user_request = "e",
  --     switch_windows = "<Tab>",
  --     reverse_switch_windows = "<S-Tab>",
  --     remove_file = "d",
  --     add_file = "@",
  --     close = { "<Esc>", "q" },
  --     close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
  --   },
  -- },

  -- selection = {
  --   enabled = true,
  --   hint_display = "delayed",
  -- },

  -- windows = {
  --   ---@type "right" | "left" | "top" | "bottom"
  --   position = "right", -- the position of the sidebar
  --   wrap = true, -- similar to vim.o.wrap
  --   width = 30, -- default % based on available width
  --   sidebar_header = {
  --     enabled = true, -- true, false to enable/disable the header
  --     align = "center", -- left, center, right for title
  --     rounded = true,
  --   },
  --   spinner = {
  --     editing = {
  --       "⡀",
  --       "⠄",
  --       "⠂",
  --       "⠁",
  --       "⠈",
  --       "⠐",
  --       "⠠",
  --       "⢀",
  --       "⣀",
  --       "⢄",
  --       "⢂",
  --       "⢁",
  --       "⢈",
  --       "⢐",
  --       "⢠",
  --       "⣠",
  --       "⢤",
  --       "⢢",
  --       "⢡",
  --       "⢨",
  --       "⢰",
  --       "⣰",
  --       "⢴",
  --       "⢲",
  --       "⢱",
  --       "⢸",
  --       "⣸",
  --       "⢼",
  --       "⢺",
  --       "⢹",
  --       "⣹",
  --       "⢽",
  --       "⢻",
  --       "⣻",
  --       "⢿",
  --       "⣿",
  --     },
  --     generating = { "·", "✢", "✳", "∗", "✻", "✽" }, -- Spinner characters for the 'generating' state
  --     thinking = { "🤯", "🙄" }, -- Spinner characters for the 'thinking' state
  --   },
  --   input = {
  --     prefix = "> ",
  --     height = 8, -- Height of the input window in vertical layout
  --   },
  --   edit = {
  --     border = "rounded",
  --     start_insert = true, -- Start insert mode when opening the edit window
  --   },
  --   ask = {
  --     floating = false, -- Open the 'AvanteAsk' prompt in a floating window
  --     start_insert = true, -- Start insert mode when opening the ask window
  --     border = "rounded",
  --     ---@type "ours" | "theirs"
  --     focus_on_apply = "ours", -- which diff to focus after applying
  --   },
  -- },

  -- highlights = {
  --   ---@type AvanteConflictHighlights
  --   diff = {
  --     current = "DiffText",
  --     incoming = "DiffAdd",
  --   },
  -- },

  -- --- @class AvanteConflictUserConfig
  -- diff = {
  --   autojump = true,
  --   ---@type string | fun(): any
  --   list_opener = "copen",
  --   --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
  --   --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
  --   --- Disable by setting to -1.
  --   override_timeoutlen = 500,
  -- },

  -- suggestion = {
  --   debounce = 600,
  --   throttle = 600,
  -- },
})

vim.api.nvim_create_augroup("AvanteCustom", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "AvanteCustom",
  pattern = "AvanteInput",
  callback = function()
    vim.cmd([[:setlocal spell spelllang=en_us]])
  end,
})
