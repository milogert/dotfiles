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
local Align = { provider = "%=" }
local Space = { provider = " " }

local ViMode = {
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
      }
    },
    mode_colors = {
      n = colors.red ,
      i = colors.green,
      v = colors.cyan,
      V =  colors.cyan,
      [""] =  colors.cyan,
      c =  colors.orange,
      s =  colors.purple,
      S =  colors.purple,
      [""] =  colors.purple,
      R =  colors.orange,
      r =  colors.orange,
      ["!"] =  colors.red,
      t =  colors.red,
    }
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

    names = names or ('? ' .. self.mode .. ' ?')

    return " %2("..names[self.mode].."%)"
  end,

  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,

  Space,
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return "[No Name]"
    end

    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end

    return filename
  end,
  -- hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
  {
    provider = function() if vim.bo.modified then return "[+]" end end,
    hl = { fg = colors.green }

  }, {
    provider = function() if (not vim.bo.modifiable) or vim.bo.readonly then return "" end end,
    hl = { fg = colors.orange }
  }
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = colors.cyan, bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  unpack(FileFlags), -- A small optimisation, since their parent does nothing
  { provider = '%<'}, -- this means that the statusline is cut here when there's not enough space
  Space
)

local FileType = {
  provider = function()
    -- return string.upper(vim.bo.filetype)
    return vim.bo.filetype
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
  Space,
}

-- local FileEncoding = {
--   provider = function()
--     local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
--     return enc ~= 'utf-8' and enc:upper()
--   end
-- }

-- local FileFormat = {
--   provider = function()
--     local fmt = vim.bo.fileformat
--     return fmt ~= 'unix' and fmt:upper()
--   end
-- }

-- local _FileSize = {
--   provider = function()
--     -- stackoverflow, compute human readable file size
--     local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
--     local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
--     fsize = (fsize < 0 and 0) or fsize
--     if fsize <= 0 then
--       return "0"..suffix[1]
--     end
--     local i = math.floor((math.log(fsize) / math.log(1024)))
--     return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
--   end
-- }

-- local FileLastModified = {
--   -- did you know? Vim is full of functions!
--   provider = function()
--     local ftime = vim.fn.getftime(vim.api.nvim_buf_gett_name(0))
--     return (ftime > 0) and os.date("%c", ftime)
--   end
-- }

-- We're getting minimalists here!
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
  Space,
}

-- I take no credits for this! :lion:
local ScrollBar = {
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
    return string.rep(self.sbar[i], 2)
  end,
  Space,
}

local LSPActive = {
  condition = conditions.lsp_attached,

  -- Or complicate things a bit and get the servers names
  provider  = function()
    local names = {}
    for _, server in ipairs(vim.lsp.buf_get_clients(0)) do
      table.insert(names, server.name)
    end

    local text = " [" .. table.concat(names, " ") .. "]"

    if not conditions.width_percent_below(#text, 0.25) then
      text = " [" .. #names .. "]"
    end

    return text
  end,

  hl = { fg = colors.green, bold = true },

  Space,
}

local Diagnostics = {
  condition = conditions.has_diagnostics,

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

  { provider = "![" },

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

  { provider = "]" },
}

-- local Navic = {
--   condition = require("nvim-navic").is_available,
--   static = {
--     -- create a type highlight map
--     type_hl = {
--       File = "Directory",
--       Module = "Include",
--       Namespace = "TSNamespace",
--       Package = "Include",
--       Class = "Struct",
--       Method = "Method",
--       Property = "TSProperty",
--       Field = "TSField",
--       Constructor = "TSConstructor ",
--       Enum = "TSField",
--       Interface = "Type",
--       Function = "Function",
--       Variable = "TSVariable",
--       Constant = "Constant",
--       String = "String",
--       Number = "Number",
--       Boolean = "Boolean",
--       Array = "TSField",
--       Object = "Type",
--       Key = "TSKeyword",
--       Null = "Comment",
--       EnumMember = "TSField",
--       Struct = "Struct",
--       Event = "Keyword",
--       Operator = "Operator",
--       TypeParameter = "Type",
--     },
--   },
--   init = function(self)
--     local data = require("nvim-navic").get_data() or {}
--     local children = {}
--     -- create a child for each level
--     for i, d in ipairs(data) do
--       local child = {
--         {
--           provider = d.icon,
--           hl = self.type_hl[d.type],
--         },
--         {
--           provider = d.name,
--           -- highlight icon only or location name as well
--           -- hl = self.type_hl[d.type],
--         },
--       }
--       -- add a separator only if needed
--       if #data > 1 and i < #data then
--         table.insert(child, {
--           provider = " > ",
--         })
--       end
--       table.insert(children, child)
--     end
--     -- instantiate the new child
--     self[1] = self:new(children, 1)
--   end,
--   hl = { fg = "gray" },
-- }

-- local FlexNavic = utils.make_flexible_component(3, Navic, { provider = "" })

local DAPMessages = {
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
  hl = { fg = utils.get_highlight('Debug').fg },
}


local GitBranch = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
  end,

  hl = { fg = colors.orange },

  {
    provider = function(self) return " " .. self.status_dict.head end,
    hl = { bold = true }
  }
}

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = colors.orange },

  GitBranch,

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
  Space,
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = colors.blue },
}

local FugitiveStatus = {
  condition = function()
    return vim.bo.filetype == "fugitive"
  end,

  hl = { fg = colors.orange },

  {
    provider = function() return " " .. vim.g.gitsigns_head end,
    hl = { bold = true }
  },
}

local DirvishFileName = {
  condition = function()
    return vim.bo.filetype == "dirvish"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":.")
  end,
  hl = { fg = colors.blue },

}

local DefaultStatusline = {
  ViMode, FileNameBlock, Git, Diagnostics, Align,

  --[[FlexNavic,]] DAPMessages, Align,

  LSPActive, FileType, Ruler, ScrollBar
}

local InactiveStatusline = {
  condition = function()
    return not conditions.is_active()
  end,

  FileNameBlock, Align, FileType,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = {"nofile", "help", "quickfix"},
      filetype = {"^git.*", "fugitive", "dirvish"}
    })
  end,

  FileType, HelpFileName, FugitiveStatus, DirvishFileName, Align,
  Ruler, ScrollBar
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,

  hl = { bg = colors.dark_red },

  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, ViMode, Space },
  FileType, --[[TerminalName,]] Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return {
        fg = utils.get_highlight("StatusLine").fg,
        bg = utils.get_highlight("StatusLine").bg
      }
    else
      return {
        fg = utils.get_highlight("StatusLineNC").fg,
        bg = utils.get_highlight("StatusLineNC").bg
      }
    end
  end,

  init = utils.pick_child_on_condition,

  SpecialStatusline, TerminalStatusline, InactiveStatusline, DefaultStatusline,
}

-- local WinBars = {
--   init = utils.pick_child_on_condition,
--   {   -- Hide the winbar for special buffers
--     condition = function()
--       return conditions.buffer_matches({
--         buftype = { "nofile", "prompt", "help", "quickfix" },
--         filetype = { "^git.*", "fugitive" },
--       })
--     end,
--     provider = "",
--   },
--   {   -- A special winbar for terminals
--     condition = function()
--       return conditions.buffer_matches({ buftype = { "terminal" } })
--     end,
--     utils.surround({ "", "" }, colors.dark_red, {
--       FileType,
--       Space,
--       -- TerminalName,
--     }),
--   },
--   {   -- An inactive winbar for regular files
--     condition = function()
--       return not conditions.is_active()
--     end,
--     utils.surround({ "", "" }, colors.bright_bg, { hl = { fg = "gray", force = true }, FileNameBlock }),
--   },
--   -- A winbar for regular files
--   utils.surround({ "", "" }, colors.bright_bg, FileNameBlock),
-- }

require('heirline').setup(StatusLines)--, WinBars)
