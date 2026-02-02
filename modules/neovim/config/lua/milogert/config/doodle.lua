local u = require("milogert.utils")
local doodle = require("doodle")

doodle.setup({
  settings = {
    -- This is the only required setting for sync to work.
    -- Set it to the absolute path of your private notes repository.
    git_repo = "/Users/milo/git/doodle",
    -- sync = true,
  },
})

u.nmap("<space>df", doodle:toggle_finder())
u.nmap("<space>ds", doodle:sync())
u.nmap("<space>dl", doodle:toggle_links())
