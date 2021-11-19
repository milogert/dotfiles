local u = require 'utils'

u.nmap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
u.nmap('<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
u.nmap('<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
u.nmap('<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

-- require('telescope').setup{
--   defaults = {
--     -- Default configuration for telescope goes here:
--     -- config_key = value,
--     mappings = {
--       i = {
--         -- map actions.which_key to <C-h> (default: <C-/>)
--         -- actions.which_key shows the mappings for your picker,
--         -- e.g. git_{create, delete, ...}_branch for the git_branches picker
--         ["<C-h>"] = "which_key"
--       }
--     }
--   },
--   pickers = {
--     -- Default configuration for builtin pickers goes here:
--     -- picker_name = {
--     --   picker_config_key = value,
--     --   ...
--     -- }
--     -- Now the picker_config_key will be applied every time you call this
--     -- builtin picker
--   },
--   extensions = {
--     -- Your extension configuration goes here:
--     -- extension_name = {
--     --   extension_config_key = value,
--     -- }
--     -- please take a look at the readme of the extension you want to configure
--   }
-- }
