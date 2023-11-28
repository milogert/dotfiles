local log = require("milogert.logger")

-- Load language configurations.
local optionals = {
  'css',
  'elixir',
  -- 'haskell',
  'html',
  'js',
  'lua',
  'nil',
  'nix',
  'terraform',
}

for _, mod in ipairs(optionals) do
  local ok, err = pcall(require, 'milogert.config.lang.' .. mod)
  if not ok then
    log.info('Failed to language config file: ' .. mod .. '.lua')
    log.error(err)
  end
end
