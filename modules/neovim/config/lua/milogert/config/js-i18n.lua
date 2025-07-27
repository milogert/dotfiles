local utils = require("js-i18n.utils")

local function default_virt_text_format(text, opts)
  local prefix = ""
  local suffix = ""
  if not opts.config.virt_text.conceal_key then
    prefix = " : "
  end

  text = utils.escape_translation_text(text)
  if opts.config.virt_text.max_length > 0 then
    text = utils.utf_truncate(text, opts.config.virt_text.max_length, "...")
  elseif opts.config.virt_text.max_width > 0 then
    text = utils.truncate_display_width(text, opts.config.virt_text.max_width, "...")
  end

  return prefix .. text .. suffix
end

require("js-i18n").setup({
  primary_language = { "en" },
  translation_source = { "**/{locales,messages}/*.json" }, -- Pattern for translation resources
  detect_language = function(path)
    return path:match("([^/]+)%.json$")
  end,


  virt_text = {
    enabled = true,    -- Enable virtual text display
    format = default_virt_text_format,      -- Format function for virtual text
    conceal_key = false, -- Hide keys and display only translations
    fallback = false,  -- Fallback if the selected virtual text cannot be displayed
    max_length = 0,    -- Maximum length of virtual text. 0 means unlimited.
    max_width = 0,     -- Maximum width of virtual text. 0 means unlimited. (`max_length` takes precedence.)
  },

  diagnostic = {
    enable = true,
    severity = vim.diagnostic.severity.INFO,
  },
})
