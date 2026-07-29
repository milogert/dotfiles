local variables = require("milogert.variables")

vim.lsp.config("cssls", {
  cmd = variables.get().ls_cmds.cssls,
})

vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "class:list", "classList", "ngClass", "cn", "cnJoin" },
    },
  },
  init_options = {
    userLanguages = {
      heex = "html-eex",
    },
  },
})

vim.lsp.enable({ "cssls", "tailwindcss" })
