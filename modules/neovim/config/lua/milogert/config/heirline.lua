local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
  red = utils.get_highlight("DiagnosticError").fg,
  green = utils.get_highlight("String").fg,
  blue = utils.get_highlight("Function").fg,
  gray = utils.get_highlight("NonText").fg,
  gray2 = utils.get_highlight("Folded").fg,
  orange = utils.get_highlight("DiagnosticWarn").fg,
  purple = utils.get_highlight("Statement").fg,
  cyan = utils.get_highlight("Special").fg,
  diag = {
    warn = utils.get_highlight("DiagnosticWarn").fg,
    error = utils.get_highlight("DiagnosticError").fg,
    hint = utils.get_highlight("DiagnosticHint").fg,
    info = utils.get_highlight("DiagnosticInfo").fg,
  },
  git = {
    del = utils.get_highlight("DiffDelete").fg,
    add = utils.get_highlight("DiffAdd").fg,
    change = utils.get_highlight("DiffChange").fg,
  },
}

local verbose_modes = true

-- Utility components
local align = { provider = "%=" }
local space = { provider = " " }

local mode_indicator = {
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },

  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if yow like it vvvvverbose!
      verbose = {
        n = "NORMAL",
        no = "YES AND",
        nov = "YES AND",
        noV = "YES AND",
        ["no"] = "YES AND",
        niI = "NORM -> insert",
        niR = "NORM -> replace",
        niV = "NORM -> visual",
        nt = "NORM TERM",
        v = "VISUAL",
        vs = "VIS SELECT",
        V = "VIS LINE",
        Vs = "VIS LINE SELECT",
        [""] = "VIS BLOCK",
        ["s"] = "VIS BLOCK SELECT",
        s = "SELECT",
        S = "SELECT LINE",
        [""] = "SELECT BLOCK",
        i = "INSERT",
        ic = "INSERT COMP",
        ix = "INSERT X-COMP",
        R = "REPLACE",
        Rc = "REPLACE COMP",
        Rx = "REPLACE X-COMP",
        Rv = "REPLACE VIRT",
        Rvc = "REPLACE VIRT COMP",
        Rvx = "REPLACE VIRT X-COMP",
        c = "CMD",
        cv = "CMD EX",
        r = "...",
        rm = "MORE",
        ["r?"] = "CONFIRM?",
        ["!"] = "SHELL",
        t = "TERM",
      },
      succinct = {
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        [""] = "^V",
        ["s"] = "^V",
        s = "S",
        S = "S_",
        [""] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
    },
    mode_colors = {
      n = colors.red,
      i = colors.green,
      v = colors.cyan,
      V = colors.cyan,
      [""] = colors.cyan,
      c = colors.orange,
      s = colors.purple,
      S = colors.purple,
      [""] = colors.purple,
      R = colors.orange,
      r = colors.orange,
      ["!"] = colors.red,
      t = colors.red,
    },
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    local names
    if verbose_modes then
      names = self.mode_names.verbose
    else
      names = self.mode_names.succinct
    end

    names = names or ("? " .. self.mode .. " ?")

    return " %2(" .. names[self.mode] .. "%)"
  end,

  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,

  space,
}

local spell = {
  condition = function()
    return vim.wo.spell
  end,
  provider = " <spell> ",
  hl = { bold = true, fg = colors.orange },
}

local file_name_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

local file_icon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local file_name = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return "[No Name]"
    end

    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end

    return filename
  end,
}

local file_flags = {
  {
    provider = function()
      if vim.bo.modified then
        return "[+]"
      end
    end,
    hl = { fg = colors.green },
  },
  {
    provider = function()
      if (not vim.bo.modifiable) or vim.bo.readonly then
        return ""
      end
    end,
    hl = { fg = colors.orange },
  },
}

local file_name_modifier = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = colors.cyan, bold = true, force = true }
    end
  end,
}

file_name_block = utils.insert(
  file_name_block,
  file_icon,
  -- a new table where FileName is a child of FileNameModifier
  utils.insert(file_name_modifier, file_name),
  -- A small optimisation, since their parent does nothing
  unpack(file_flags),
  -- this means that the statusline is cut here when there's not enough space
  { provider = "%<" },
  space
)

local file_type = {
  provider = function()
    -- return string.upper(vim.bo.filetype)
    return vim.bo.filetype
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
  space,
}

local ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  -- provider = "%7(%l/%3L%):%2c %P",
  provider = "%7(%l/%3L%):%2c",
  space,
}

-- local scrollbar = {
--   static = {
--     -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
--     sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
--   },
--   provider = function(self)
--     local curr_line = vim.api.nvim_win_get_cursor(0)[1]
--     local lines = vim.api.nvim_buf_line_count(0)
--     local i
--     if lines > 0 then
--       i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
--     else
--       i = #self.sbar
--     end
--     return string.rep(self.sbar[i], 2)
--   end,
--   space,
-- }

local lsp_indicator = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  -- Or complicate things a bit and get the servers names
  provider = function()
    local names = {}
    for _, server in ipairs(vim.lsp.buf_get_clients(0)) do
      table.insert(names, server.name)
    end

    local text = " " .. table.concat(names, " ")

    if not conditions.width_percent_below(#text, 0.25) then
      text = " " .. #names
    end

    return text
  end,

  hl = { fg = colors.green, bold = true },

  space,
}

local diagnostic_icons = {
  condition = conditions.has_diagnostics,
  update = { "DiagnosticChanged", "BufEnter" },

  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = colors.diag.error },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = colors.diag.warn },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = colors.diag.info },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = colors.diag.hint },
  },
}

local dap_messages = {
  -- display the dap messages only on the debugged file
  condition = function()
    local session = require("dap").session()
    if session then
      return true
    end
    if session then
      local filename = vim.api.nvim_buf_get_name(0)
      if session.config then
        local progname = session.config.program
        return filename == progname
      end
    end
    return false
  end,
  provider = function()
    return " " .. require("dap").status()
  end,
  hl = { fg = utils.get_highlight("Debug").fg },
}

local git_branch = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
  end,

  hl = { fg = colors.orange },

  {
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true },
  },
}

local git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = colors.orange },

  git_branch,

  -- You could handle delimiters, icons and counts similar to Diagnostics
  -- {
  --   condition = function(self)
  --     return self.has_changes
  --   end,
  --   provider = "("
  -- },
  -- {
  --   provider = function(self)
  --     local count = self.status_dict.added or 0
  --     return count > 0 and ("+" .. count)
  --   end,
  --   hl = { fg = colors.git.add },
  -- },
  -- {
  --   provider = function(self)
  --     local count = self.status_dict.removed or 0
  --     return count > 0 and ("-" .. count)
  --   end,
  --   hl = { fg = colors.git.del },
  -- },
  -- {
  --   provider = function(self)
  --     local count = self.status_dict.changed or 0
  --     return count > 0 and ("~" .. count)
  --   end,
  --   hl = { fg = colors.git.change },
  -- },
  -- {
  --   condition = function(self)
  --     return self.has_changes
  --   end,
  --   provider = ")",
  -- },
  space,
}

local special_help_file = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = colors.blue },
}

local special_fugitive = {
  condition = function()
    return vim.bo.filetype == "fugitive"
  end,

  hl = { fg = colors.orange },

  {
    provider = function()
      return " " .. vim.g.gitsigns_head
    end,
    hl = { bold = true },
  },
}

local special_dirvish = {
  condition = function()
    return vim.bo.filetype == "dirvish"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":.")
  end,
  hl = { fg = colors.blue },
}

local statusline_default = {
  mode_indicator,
  spell,
  file_name_block,
  git,
  diagnostic_icons,
  align,

  dap_messages,
  align,

  lsp_indicator,
  file_type,
  ruler,
  --scrollbar,
}

local statusline_inactive = {
  condition = function()
    return not conditions.is_active()
  end,

  file_name_block,
  diagnostic_icons,
  align,
  file_type,
}

local statusline_special = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "help", "quickfix" },
      filetype = { "^git.*", "fugitive", "dirvish" },
    })
  end,

  file_type,
  special_help_file,
  special_fugitive,
  special_dirvish,
  align,
  ruler,
  --scrollbar,
}

local statusline_terminal = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,

  hl = { bg = colors.dark_red },

  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, mode_indicator, space },
  file_type, --[[TerminalName,]]
  align,
}

local statuslines = {
  hl = function()
    if conditions.is_active() then
      return {
        fg = utils.get_highlight("StatusLine").fg,
        bg = utils.get_highlight("StatusLine").bg,
      }
    else
      return {
        fg = utils.get_highlight("StatusLineNC").fg,
        bg = utils.get_highlight("StatusLineNC").bg,
      }
    end
  end,

  fallthrough = false,

  statusline_special,
  statusline_terminal,
  statusline_inactive,
  statusline_default,
}

require("heirline").setup({
  statusline = statuslines,
})
