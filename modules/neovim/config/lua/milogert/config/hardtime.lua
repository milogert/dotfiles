require("hardtime").setup({
  restriction_mode = 'block',
})

-- vim.cmd [[ nmap <space>h :lua print('Hello')<cr> ]]
vim.cmd [[ nmap <space>hs :lua print('Hello space')<cr> ]]
vim.cmd [[ nmap <leader>hl :lua print('Hello leader')<cr> ]]
