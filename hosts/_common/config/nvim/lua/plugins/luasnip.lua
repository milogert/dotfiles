local ls = require("luasnip")

-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

-- Every unspecified option will be set to the default.
ls.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
})

ls.snippets = {
  all = {
  },
  html = {
  },
  -- javascriptreact = {
  --   s("fcomp", {
  --     t('const '),
  --     i(1),
  --     t(" = "),
  --     c(2, {
  --       sn(nil, {
  --         t("({ "),
  --         i(1),
  --         t(" })"),
  --       }),
  --       t("props"),
  --     }),
  --     t(" = {", ""),
  --     i(0),
  --     t("}", ""),
  --     t("", "export default "),
  --     i(3),
  --   })
  -- },
}

-- enable html snippets in javascript/javascript(REACT)
ls.snippets.javascript = ls.snippets.html
ls.snippets.javascriptreact = ls.snippets.html
ls.snippets.typescriptreact = ls.snippets.html
require("luasnip/loaders/from_vscode").load({include = {"html"}})

-- You can also use lazy loading so you only get in memory snippets of languages you use
require'luasnip/loaders/from_vscode'.lazy_load()
