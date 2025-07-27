require("other-nvim").setup({
  mappings = {
    -- builtin mappings
    "livewire",
    "angular",
    "laravel",
    "rails",
    "golang",
    -- "python",
    -- "react",
    "rust",
    "elixir",

    -- custom mapping
    {
      pattern = "^(.*)/components/page%-components/(.*)/(.*).tsx$",
      target = {
        { target = "%1/components/page-components/%2/%3-view.tsx", context = "view component" },
        { target = "%1/components/page-components/%2/%3-edit.tsx", context = "editor component" },
        { target = "%1/components/page-components/%2/%3-schema.ts", context = "schema" },
        { target = "%1/(editor)/event/[eventId]/components/emails/components/%3.tsx", context = "email" },
      },
    },
    {
      pattern = "/path/to/file/src/app/(.*)/.*.ext$",
      target = "/path/to/file/src/view/%1/",
      transformer = "lowercase",
    },
  },

  showMissingFiles = true,

  transformers = {
    -- defining a custom transformer
    lowercase = function(inputString)
      return inputString:lower()
    end,
  },

  hooks = {
    -- This hook which is executed when the file-picker is shown.
    -- It could be used to filter or reorder the files in the filepicker.
    -- The function must return a lua table with the same structure as the input parameter.
    --
    -- The input parameter "files" is a lua table with each entry containing:
    -- @param table (filename (string), context (string), exists (boolean))
    -- @return table | boolean When an empty table or false is returned the filepicker is not openend.
    filePickerBeforeShow = function(files)
      return files
    end,

    -- This hook is called whenever a file is about to be opened.
    -- One example how this can be used: a non existing file needs to be opened by another plugin, which provides a template.
    --
    -- @param filename (string) the full-path of the file
    -- @param exists (boolean) doess the file already exist
    -- @return (boolean) When true (default) the plugin takes care of opening the file, when the function returns false this indicated that opening of the file is done in the hook.
    onOpenFile = function(filename, exists)
      return true
    end,

    -- This hook is called whenever the plugin tries to find other files.
    -- It returns the matches found by the plugin. It can be used to filter or reorder the files or use the matches with another plugin.
    --
    -- @param matches (table) lua table with each entry containing: (filename (string), context (string), exists (boolean))
    -- @return (matches) Make sure to return the matches, otherwise the plugin will not work as expected.
    onFindOtherFiles = function(matches)
      return matches
    end,
  },

  style = {
    -- How the plugin paints its window borders
    -- Allowed values are none, single, double, rounded, solid and shadow
    border = "solid",

    -- Column seperator for the window
    seperator = "|",

    -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
    width = 0.7,

    -- min height in rows.
    -- when more columns are needed this value is extended automatically
    minHeight = 2,
  },
})
