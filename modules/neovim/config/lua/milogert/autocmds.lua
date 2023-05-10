local u = require('milogert.utils')
local log = require('milogert.logger')

-- augroups and autocmd
vim.api.nvim_create_augroup('formatting', { clear = true })
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   group = 'formatting',
--   desc = 'Format Elixir files on save',
--   pattern = { '*.exs', '*.ex' },
--   command = 'silent !mix format %',
-- })

vim.api.nvim_create_augroup('lsp', { clear = true })
-- vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--   group = 'lsp',
--   desc = 'Show diagnotics on hover.',
--   callback = function ()
--     vim.diagnostic.open_float()
--   end,
-- })

vim.api.nvim_create_augroup('skeletons', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'skeletons',
--   desc = 'Insert a common git commit format, unless it\'s a merge commit',
--   pattern = 'gitcommit',
--   callback = function()
--     local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
--     local is_merge = string.sub(first_line, 1, 5) == 'Merge'
--     local is_template = string.match(first_line, "Feel free") ~= nil
--     if not (is_merge or is_template) then
--       vim.api.nvim_command('0r '..vim.g.configPath..'/skeletons/gitcommit.skeleton')
--     end
--   end
-- })

vim.api.nvim_create_augroup('dadbod-auto-configure', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'dadbod-auto-configure',
  desc = 'Parse docker compose and set up database variables',
  pattern = '*',
  callback = function()
    local file = vim.fn.getcwd()..'/docker-compose.override.yml'
    local has_docker_compose = u.file_exists(file)
    if not has_docker_compose then
      return
    end

    local paths = {
      ".services.postgres.ports[0]",
      ".services.db.ports[0]",
    }

    local ports = nil
    for _, path in ipairs(paths) do
      ports = vim.fn.system({ "yq", "-r", path, file })

      if ports then
        break
      end
    end

    local local_port = u.split(ports, ":")[1]

    vim.g.db_port = "postgres://postgres@localhost:"..local_port.."/postgres"
    u.nmap('<Leader>dbc', ':DB g:db_port<CR>')
    log.info("Found a docker-compose db. Use <Leader>dbc to connect")
  end
})

-- vim.api.nvim_create_autocmd('BufNew,BufRead', {
--   pattern = '*/pre-incidents/*',
-- })
-- autocmd BufNewFile,BufRead /specificPath/** imap <buffer> ....

-- vim-commentary
-- vim.api.nvim_create_augroup('vim-commentary', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'vim-commentary',
--   desc = 'React comments',
--   pattern = 'javascriptreact',
--   command = 'setlocal commentstring={/* %s */}'
-- })

-- From 
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(ctx)
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ':p:h'), 'p')
  end
})

-- Haskell Filetypes
-- vim.api.nvim_create_augroup('haskell-file-types', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--   group = 'haskell-file-types',
--   desc = 'Parse docker compose and set up database variables',
--   pattern = { '*.hamlet', '*.lucius', '*.julius', '*.cassius' },
--   callback = function(ev)
--     local splits = u.split(ev.file, '.')
--     local extension = splits[#splits]
--     vim.api.nvim_command('set ft='..extension)
--   end
-- })
