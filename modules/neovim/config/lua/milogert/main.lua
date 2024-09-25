local M = {}
local variables = require("milogert.variables")
local u = require("milogert.utils")

M.setup = function(variable_opts)
  variables.setup(variable_opts)

  local log = require("milogert.logger")

  -- https://github.com/neovim/neovim/issues/21749#issuecomment-1378720864
  -- Fix loading of json5
  table.insert(vim._so_trails, "/?.dylib")

  -- Set the leader key. This should be first.
  require("milogert.settings")
  require("milogert.autocmds")

  -- Source plugin configs.
  local plugins = {
    "arpeggio",
    "cmp",
    "colorizer",
    "comment",
    -- "copilot",
    "dressing",
    "dap",
    "devcontainer",
    "dressing",
    "fidget",
    "fzf-lua",
    "gitsigns",
    "keybindings",
    "lsp.installer",
    "luasnip",
    "none-ls",
    "octo",
    "oil",
    "output-panel",
    "package-info",
    "persistence",
    "runscript",
    "supermaven",
    "tada",
    "treesitter",

    "heirline", -- Needs to be last since it uses info from other imports
  }

  for _, plugin in ipairs(plugins) do
    local ok, err = pcall(require, "milogert.config." .. plugin)
    if not ok then
      log.error("Failed to load plugin config: " .. plugin)
      log.error(err)
    end
  end

  -- Load optional files.
  local optionals = {
    "playground",
    "priv",
  }

  for _, mod in ipairs(optionals) do
    local ok, err = pcall(require, mod)
    if not ok then
      log.info("Failed to load file: " .. mod .. ".lua")
      log.error(err)
    end
  end

  -- Perform language setup.
  require("milogert.config.lang.main")

  -- Dirvish - override netrw when using Explore, Sexplore, and Vexplore.
  -- vim.g.loaded_netrwPlugin = 'loaded due to dirvish'
  -- for _, value in ipairs({ { 'Explore', '' }, { 'Sexplore', 'split | silent ' }, { 'Vexplore', 'vsplit | silent ' } }) do
  --   vim.api.nvim_create_user_command(
  --     value[1],
  --     function(opts)
  --       vim.cmd(value[2] .. 'Dirvish ' .. opts.fargs[1])
  --     end,
  --     { nargs = '?', complete = 'dir' }
  --   )
  -- end

  vim.cmd([[
  " Function to source only if file exists.
  function! SourceIfExists(file)
    if filereadable(expand(a:file))
      exe 'source' a:file
    endif
  endfunction

  function! TwiddleCase(str)
    if a:str ==# toupper(a:str)
      let result = tolower(a:str)
    elseif a:str ==# tolower(a:str)
      let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
    else
      let result = toupper(a:str)
    endif
    return result
  endfunction
  vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

  " Source other files.
  call SourceIfExists("~/.config/nvim/profile.vim")

  function! Scratch()
    vsplit
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
  endfunction
  ]])
end

return M
