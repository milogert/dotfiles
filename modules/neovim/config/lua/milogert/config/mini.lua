local u = require "milogert.utils"
local log = require "milogert.logger"

-- local sessions = require('mini.sessions')

-- sessions.setup({
--   autoread = true,
-- })

-- u.nmap('<Leader>sr', '', { callback = function ()
--   sessions.read(sessions.get_latest())
-- end })


-- local starter = require('mini.starter')
--
-- starter.setup({
--   autoopen = true,
--   header = function ()
--     local handle = io.popen("neofetch -L | sed 's/\\x1B\\[[?0-9;]*[mlADh]//g'")
--
--     if handle == nil then
--       log.info("Failed to run neofetch")
--       return "Hey buddy"
--     end
--
--     local result = handle:read("*a")
--     handle:close()
--     return u.trim(result, true)
--   end,
--   items = {
--     starter.sections.builtin_actions(),
--     starter.sections.recent_files(10, true),
--     -- starter.sections.recent_files(10, false),
--     {
--       name = 'Restore session',
--       action = 'lua require("persistence").load()',
--       section = 'Builtin actions',
--     },
--     {
--       name = 'Find files',
--       action = 'lua require("milogert.functions").fzfFiles()',
--       section = 'Builtin actions',
--     },
--   },
--   content_hooks = {
--     starter.gen_hook.adding_bullet("==> "),
--     starter.gen_hook.indexing('all', { 'Builtin actions' }),
--     -- starter.gen_hook.padding(9, 5),
--     starter.gen_hook.aligning('center', 'center'),
--   },
-- })
