-- Keybindings.

local u = require("milogert.utils")
local f = require("milogert.functions")

-- Config maps.
u.nmap("<leader>re", ":tabnew $MYVIMRC<CR>")
u.nmap("<leader>rs", ":so $MYVIMRC<CR>")

-- gF opens the file under the cursor in a new split.
u.nmap("gF", "<C-w>vgf")

-- Enter key starts prompt.
-- u.nmap('<CR>', ':')

-- Fast switch between buffers by pressing leader twice.
u.nmap("<leader><leader>", "<c-^>")

-- Make Y act like C and D
u.nmap("Y", "y$")

-- Swap ` and ' for marks, since ` (by default) jumps to line and column.
u.nmap("'", "`")
u.nmap("`", "'")

-- Remap the arrow keys to do nothing.
u.map("<Up>", "<nop>")
u.map("<Down>", "<nop>")
u.map("<Left>", "<nop>")
u.map("<Right>", "<nop>")
u.imap("<Up>", "<nop>")
u.imap("<Down>", "<nop>")
u.imap("<Left>", "<nop>")
u.imap("<Right>", "<nop>")

-- Remap j/k to gj/gk but only when we are not counting.
local jkMapOpts = { noremap = true, silent = true, expr = true }
u.map("j", '(v:count == 0 ? "gj" : "j")', jkMapOpts)
u.map("k", '(v:count == 0 ? "gk" : "k")', jkMapOpts)

-- Fugitive
-- u.nmap('<leader>g', ':G<CR>')

-- Tmuxinator helpers.
-- u.nmap('<leader>ms', ':Mux start ', { silent = false })
-- u.nmap('<leader>mc', ':Mux stop ', { silent = false })

-- Escape quickly.
u.imap("jj", "<Esc>")
u.imap("jk", "<Esc>")
u.arpeggio("inoremap", "jk", "<Esc>")

-- Vimux keys.
local vimuxMaps = {
  { key = "vp", command = "PromptCommand" },
  { key = "vl", command = "RunLastCommand" },
  { key = "vz", command = "ZoomRunner" },
  { key = "vs", command = "InterruptRunner" },
  { key = "vx", command = "CloseRunner" },
}

for _, map in ipairs(vimuxMaps) do
  local command = ":Vimux" .. map.command .. "<CR>"
  u.nmap("<leader>" .. map.key, command)
  u.arpeggio("nnoremap", map.key, command)
end

-- Function keybindings.
u.nmap("<leader>fl", "", {
  callback = f.addNonConditionalLogger,
})
u.nmap("<leader>cfl", "", {
  callback = f.addConditionalLogger,
})
u.nmap("<leader>ppj", "", {
  callback = f.prettyPrintJsonFile,
})
u.xmap("<leader>ppj", "", {
  callback = f.prettyPrintJsonVisual,
})

-- Split lines? Probably not..
-- nnoremap S :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

-- Sort while highlighting something.
u.xmap("u", [[:'<,'>sort<cr>]])

u.nmap("dd", "", { callback = f.smart_dd, expr = true })

local git_permalink = require("git-permalink")
u.nmap("<Leader>gl", "", {
  callback = function()
    git_permalink.create_copy(".")
  end,
})
u.vmap("<Leader>gl", "", {
  callback = function()
    git_permalink.create_copy("v")
  end,
})

-- Spellcheck
u.nmap("<F11>", ":set spell!<CR>")
u.imap("<F11>", "<C-O>:set spell!<CR>")
u.nmap("<leader>sp", ":set spell!<CR>")

u.nmap(
  "<Leader>gt",
  ':G add % | G commit -m "" | G push<left><left><left><left><left><left><left><left><left><left>'
)

u.map("<leader>tn", ":tabnew<cr>")

u.map("<leader>db", ":tabnew | DBUI<cr>")
