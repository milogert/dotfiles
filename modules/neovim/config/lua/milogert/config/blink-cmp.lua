local blink = require("blink.cmp")

blink.setup({
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = {
    -- preset = "default",
    -- ["<C-n>"] = { "show", "fallback" },

    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },

    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },

    ["<Up>"] = { "snippet_backward", "fallback" },
    ["<Down>"] = { "snippet_forward", "fallback" },
    ["<C-p>"] = { "snippet_backward", "fallback_to_mappings" },
    ["<C-n>"] = { "show", "snippet_forward", "fallback_to_mappings" },

    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },

    ["<C-d>"] = { "show", "show_documentation", "hide_documentation" },
    -- ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
    kind_icons = {
      Text = "",
      Method = "ƒ",
      Function = "",
      Constructor = "",
      Variable = "",
      Class = "",
      Interface = "ﰮ",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "了",
      Keyword = "",
      Snippet = "﬌",
      Color = "",
      File = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Supermaven = "",
      supermaven = "",
    },
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    accept = {
      auto_brackets = {
        -- Whether to auto-insert brackets for functions
        enabled = false,
      },
    },

    list = {
      selection = {
        preselect = false,
      },
    },

    menu = {
      max_height = 18,

      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },

      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ =
                  require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = require("lspkind").symbolic(ctx.kind, {
                  mode = "symbol",
                })
              end

              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from nvim-web-devicons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, dev_hl =
                  require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          },
        },

        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", gap = 1, "kind" },
          { "source_name" },
        },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 1,
      -- Uncomment this if cpu is high when opening the completion menu.
      -- treesitter_highlighting = false,
      window = {
        border = {
          { "╭", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╮", "FloatBorder" },
          { "│", "FloatBorder" },
          { "╯", "FloatBorder" },
          { "─", "FloatBorder" },
          { "╰", "FloatBorder" },
          { "│", "FloatBorder" },
        },
      },
    },
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { "git", "avante", "snippets", "lsp", "buffer", "path" },

    per_filetype = {
      octo = { "snippets" },
      sql = { "snippets", "dadbod", "buffer" },
    },

    providers = {
      avante = {
        name = "Avante",
        module = "blink-cmp-avante",
        opts = {
          -- options for blink-cmp-avante
        },
      },

      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },

      git = {
        module = "blink-cmp-git",
        name = "Git",
        -- only enable this source when filetype is gitcommit, markdown, or 'octo'
        enabled = function()
          return vim.tbl_contains(
            { "octo", "gitcommit", "markdown" },
            vim.bo.filetype
          )
        end,

        --- @module 'blink-cmp-git'
        --- @type blink-cmp-git.Options
        opts = {
          -- options for the blink-cmp-git
        },
      },

      -- supermaven = {
      --   name = "supermaven",
      --   module = "blink-cmp-supermaven",
      --   async = true,
      -- },
    },
  },

  signature = { enabled = false },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
  --
  -- See the fuzzy documentation for more information
  fuzzy = { implementation = "prefer_rust_with_warning" },

  cmdline = {
    -- keymap = {
    -- ["<CR>"] = { "fallback" },
    -- preset = "inherit",
    -- },
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },

      menu = { auto_show = true },
    },
  },
})
