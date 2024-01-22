local u = require('milogert.utils')

local path = os.getenv("PWD") or io.popen("cd"):read()
local splitPath = u.split(path, "/")
local dir = string.gsub(splitPath[#splitPath], '^%.', '_')
local file = os.getenv("HOME").."/todos/"..dir..".tada"
vim.g.tada_todo_pane_file = file
vim.g.tada_todo_pane_map = '<Leader>td'
vim.g.tada_map_box = '<C-\\>'
vim.g.tada_todo_switch_status_mapping = '\\'
