local fzf = require 'fzf-lua'
local logger = require 'milogert.logger'

fzf.setup {
  winopts = {
    preview = {
      default = 'bat',
    },
  },
}

local in_tmux = function ()
  return os.getenv('TMUX') ~= nil
end

return function ()
  local get_contents = function (fzf_cb)
    local stdout = io.popen('tmux list-sessions', 'r')
    if stdout == nil then
      print('uh oh')
      return
      fzf_cb()
    end

    local output = stdout:read('a')
    stdout:close()

    logger.plenary.info('block', output)

    for name, window_count, created_at in string.gmatch(output, '([^\n:]+): (%d+) windows %(created ([^)]+)%)') do
      -- fzf_cb(string.format('%s - %s - %s', name, window_count, created_at))
      fzf_cb(name)
    end

    -- print(lines[1])
    -- for _, line in ipairs(lines) do
    --   local matcher = string.gmatch(line, '(.+): (%d+) %(created (.+)%)')
    --   local name = matcher()
    --   local window_count = matcher()
    --   local date_created = matcher()

    -- end

    fzf_cb()
  end

  fzf.fzf_exec(get_contents, {
    fzf_opts = {
      ["--no-multi"] = "", -- TODO this can support multi, maybe.
      -- ["--delimiter"] = "' - '",
      -- ["--with-nth"] = "1",
    },
    actions = {
      ['default'] = function (selected)
        -- local name, window_count, date_created = unpack(vim.split(selected[1], ' - '))
        -- print('selected thing', name, window_count, date_created)

        if in_tmux() then
          os.execute(string.format('tmux switch -t %s', selected[1]))
        else
          os.execute(string.format('tmux attach -t %s', selected[1]))
        end
      end,
    },
  })
end
