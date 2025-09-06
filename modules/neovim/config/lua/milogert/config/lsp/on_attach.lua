local u = require("milogert.utils")
vim.diagnostic.config({
  source = true,
})

local fzf = require("fzf-lua")
-- local conform = require("conform")

-- Use an on_attach function to only map the following keys
-- after the language server attachs to the current buffer
local on_attach = function(_client, bufnr)
  local default_opts = { buffer = bufnr }

  u.nmap("<leader>e", vim.diagnostic.open_float, default_opts)
  u.nmap("<leader>q", vim.diagnostic.setloclist, default_opts)
  u.nmap("<leader>c", vim.diagnostic.setqflist, default_opts)
  u.nmap("gD", fzf.lsp_declarations, default_opts)
  u.nmap("gd", fzf.lsp_definitions, default_opts)
  u.nmap("K", function()
    vim.lsp.buf.hover({
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
    })
  end, default_opts)
  u.nmap("gi", fzf.lsp_implementations, default_opts)
  u.nmap("[ls", vim.lsp.buf.signature_help, default_opts)
  u.nmap("<leader>D", fzf.lsp_typedefs, default_opts)
  u.nmap("<leader>rn", vim.lsp.buf.rename, default_opts)
  u.nmap("gr", fzf.lsp_references, default_opts)
  u.nmap("<leader>ca", vim.lsp.buf.code_action, default_opts)

  -- Set some keybinds conditional on server capabilities
  -- TODO which capability is correct? I think the "Provider" version is but I
  -- am unsure.
  -- local can_format = client.server_capabilities.document_formatting
  --   or client.server_capabilities.documentFormattingProvider
  -- if can_format then
  --   u.nmap("<leader>fi", function()
  --     conform.format({ bufnr = bufnr })
  --   end, default_opts)
  -- end
end

return on_attach
