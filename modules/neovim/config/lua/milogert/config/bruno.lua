require("bruno").setup({
  -- Paths to your bruno collections.
  collection_paths = {
    {
      name = "Bruno",
      path = "./bruno",
    },
  },
  -- Which picker to use, "fzf-lua" or "snacks" are also allowed.
  picker = "fzf-lua",
  -- If output should be formatted by default.
  show_formatted_output = true,
  -- If formatting fails for whatever reason, don't show error message (will always fallback to unformatted output).
  suppress_formatting_errors = false,
})
