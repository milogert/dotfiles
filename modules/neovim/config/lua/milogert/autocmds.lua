local u = require("milogert.utils")
local log = require("milogert.logger")
local variables = require("milogert.variables")

local augroup_misc = vim.api.nvim_create_augroup("misc", { clear = true })
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = augroup_misc,
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
  end,
})

local augroup_dadbod = vim.api.nvim_create_augroup("dadbod-auto-configure", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup_dadbod,
  desc = "Parse docker compose and set up database variables",
  pattern = "*",
  callback = function()
    local file = vim.fn.getcwd() .. "/docker-compose.override.yml"
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

    vim.g.db_port = "postgres://postgres@localhost:" .. local_port .. "/postgres"
    u.nmap("<Leader>dbc", ":DB g:db_port<CR>")
    log.info("Found a docker-compose db. Use <Leader>dbc to connect")
  end,
})

-- From
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(ctx)
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ":p:h"), "p")
  end,
})

-- Yank ring
-- Possible alternative: https://github.com/gbprod/yanky.nvim
-- https://www.reddit.com/r/neovim/comments/1jv03t1/simple_yankring/?rdt=49637
-- Shift numbered registers up (1 becomes 2, etc.)
local function yank_shift()
  for i = 9, 1, -1 do
    vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
  end
end

-- Create autocmd for TextYankPost event
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local event = vim.v.event
    if event.operator == "y" then
      yank_shift()
    end
  end,
})
