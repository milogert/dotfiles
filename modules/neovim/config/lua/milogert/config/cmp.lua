-- Copied from https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Require function for tab to work with luasnip.
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      menu = {
        -- dictionary = "[Dict]",
        buffer = "[Buff]",
        latex_symbols = "[LaTeX]",
        luasnip = "[Snip]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        copilot = "[Copilot]",
      },
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 100 },
    { name = "supermaven" },
    -- { name = "copilot" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "luasnip" },
    { name = "calc" },
    { name = "git" },
  }, {
    { name = "buffer", keyword_length = 1 },
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.exact,
      -- require("copilot_cmp.comparators").score,
      cmp.config.compare.offset,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.scopes,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.order,
      cmp.config.compare.length,
    },
  },
  experimental = {
    ghost_text = { enabled = true },
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Setup after including as a source?
require("cmp_git").setup()

vim.api.nvim_create_augroup("cmp-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "cmp-custom",
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require("cmp").setup.buffer({
      sources = { { name = "vim-dadbod-completion" } }
    })
  end,
})
