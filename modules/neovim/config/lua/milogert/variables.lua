-- vim.g.ls_installs needs to be defined (this comes from my Nix config at the
-- moment).
local installs = vim.g.ls_installs

vim.g.ls_cmds = {
  cssls = { installs.html .. "vscode-css-language-server", "--stdio" },
  -- denols = { installs.denols .. "deno", "lsp" },
  elixirls = { installs.elixirls .. "elixir-ls" },
  eslint = { installs.eslint .. "vscode-eslint-language-server", "--stdio" },
  html = { installs.html .. "vscode-html-language-server", "--stdio" },
  jsonls = { installs.jsonls .. "vscode-json-language-server", "--stdio" },
  lua_ls = { installs.lua_ls .. "lua-language-server" },
  nil_ls = { installs.nil_ls .. "nil" },
  rnix = { installs.rnix .. "rnix-lsp" },
  stylua = { installs.stylua .. "stylua" },
  tailwindcss = {
    installs.tailwindcss .. "tailwindcss-language-server",
    "--stdio",
  },
  terraformls = { installs.terraformls .. "terraform-ls", "serve" },
  tsserver = {
    installs.tsserver .. "typescript-language-server",
    "--stdio",
    "--tsserver-path",
    "tsserver",
  },
}
