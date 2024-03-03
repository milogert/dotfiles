local reactive = require('reactive')
local logger = require('milogert.logger')

local bright_black = vim.g.srcery_bright_black
local bright_blue = vim.g.srcery_bright_blue
local bright_cyan = vim.g.srcery_bright_cyan
local bright_green = vim.g.srcery_bright_green
local bright_magenta = vim.g.srcery_bright_magenta
local bright_orange = vim.g.srcery_bright_orange
local bright_red = vim.g.srcery_bright_red
local bright_white = vim.g.srcery_bright_white
local bright_yellow = vim.g.srcery_bright_yellow
local black = vim.g.srcery_black
local blue = vim.g.srcery_blue
local cyan = vim.g.srcery_cyan
local green = vim.g.srcery_green
local magenta = vim.g.srcery_magenta
local orange = vim.g.srcery_orange
local red = vim.g.srcery_red
local white = vim.g.srcery_white
local yellow = vim.g.srcery_yellow
local gray1 = vim.g.srcery_xgray1
local gray2 = vim.g.srcery_xgray2
local gray3 = vim.g.srcery_xgray3
local gray4 = vim.g.srcery_xgray4
local gray5 = vim.g.srcery_xgray5
local gray6 = vim.g.srcery_xgray6

local bright_purple = '#c97bff'
local purple = '#a259ff'
local hard_purple = '#6c3f99'

-- logger.plenary.info({
--   bright_black = bright_black,
--   bright_blue = bright_blue,
--   bright_cyan = bright_cyan,
--   bright_green = bright_green,
--   bright_magenta = bright_magenta,
--   bright_orange = bright_orange,
--   bright_red = bright_red,
--   bright_white = bright_white,
--   bright_yellow = bright_yellow,
--   black = black,
--   blue = blue,
--   cyan = cyan,
--   green = green,
--   magenta = magenta,
--   orange = orange,
--   red = red,
--   white = white,
--   yellow = yellow,
-- })



reactive.add_preset({
  name = 'cursor',
  init = function()
    vim.opt.guicursor:append 'a:ReactiveCursor'
  end,
  modes = {
    [{ 'i', 'niI' }] = {
      hl = {
        ReactiveCursor = { bg = cyan },
      },
    },
    n = {
      hl = {
        ReactiveCursor = { bg = yellow },
      },
    },
    no = {
      operators = {
        d = {
          hl = {
            ReactiveCursor = { bg = bright_red },
          },
        },
        y = {
          hl = {
            ReactiveCursor = { bg = bright_orange },
          },
        },
        c = {
          hl = {
            ReactiveCursor = { bg = bright_blue },
          },
        },
      },
    },
    [{ 'v', 'V', '\x16' }] = {
      hl = {
        ReactiveCursor = { bg = bright_purple },
      },
    },
    c = {
      hl = {
        ReactiveCursor = { bg = yellow },
      },
    },
    [{ 's', 'S', '\x13' }] = {
      hl = {
        ReactiveCursor = { bg = bright_magenta },
      },
    },
    [{ 'R', 'niR', 'niV' }] = {
      hl = {
        ReactiveCursor = { bg = bright_cyan },
      },
    },
  },
})

reactive.add_preset({
  name = 'cursorline',
  init = function()
    vim.opt.cursorline = true
  end,
  static = {
    winhl = {
      inactive = {
        CursorLine = { bg = black },
        CursorLineNr = { fg = gray6, bg = black },
      },
    },
  },
  modes = {
    no = {
      operators = {
        -- switch case
        [{ 'gu', 'gU', 'g~', '~' }] = {
          winhl = {
            CursorLine = { bg = '#334155' },
            CursorLineNr = { fg = '#cbd5e1', bg = '#334155' },
          },
        },
        -- change
        c = {
          winhl = {
            CursorLine = { bg = blue },
            CursorLineNr = { fg = bright_blue, bg = blue },
          },
        },
        -- delete
        d = {
          winhl = {
            -- CursorLine = { bg = '#350808' },
            CursorLineNr = { fg = bright_red, bg = gray2 },
          },
        },
        -- yank
        y = {
          winhl = {
            CursorLine = { bg = '#422006' },
            CursorLineNr = { fg = '#fdba74', bg = '#422006' },
          },
        },
      },
    },
    i = {
      winhl = {
        -- CursorLine = { bg = '#012828' },
        CursorLineNr = { fg = cyan, bg = gray2 },
      },
    },
    c = {
      winhl = {
        -- CursorLine = { bg = '#202020' },
        CursorLineNr = { fg = bright_white, bg = gray2 },
      },
    },
    n = {
      winhl = {
        CursorLine = { bg = gray2 },
        CursorLineNr = { fg = bright_yellow, bg = gray2 },
      },
    },
    -- visual
    [{ 'v', 'V', '\x16' }] = {
      winhl = {
        CursorLineNr = { fg = bright_purple },
        Visual = { bg = hard_purple },
      },
    },
    -- select
    [{ 's', 'S', '\x13' }] = {
      winhl = {
        CursorLineNr = { fg = bright_purple },
        Visual = { bg = hard_purple },
      },
    },
    -- replace
    R = {
      winhl = {
        CursorLine = { bg = '#083344' },
        CursorLineNr = { fg = cyan, bg = '#083344' },
      },
    },
  },
})

reactive.setup {
  -- load = { 'cursor', 'cursorline' },
}
