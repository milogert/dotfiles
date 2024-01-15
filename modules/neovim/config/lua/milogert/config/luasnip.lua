local ls = require("luasnip")
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local fmt = require("luasnip.extras.fmt").fmt
-- local m = require("luasnip.extras").m
-- local lambda = require("luasnip.extras").l

-- Every unspecified option will be set to the default.
ls.config.set_config({
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
})

-- local functional_logger_def =
--   s('fld', {
--     t('const fl = tag => logData => ( console.log(`luasnip.lua: ${tag}`, logData), logData )')
--   })
--
-- local functional_logger_use = s('flu', { t("fl('"), i(1, 'tag'), t("'),") })
--
-- ls.add_snippets("all", {
--   functional_logger_def,
--   functional_logger_use,
--   s("ternary", {
--     -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
--     i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
--   })
-- })

-- You can also use lazy loading so you only get in memory snippets of languages you use
require('luasnip.loaders.from_vscode').lazy_load()
