local default_markers = { ".git" }

local M = {}

--[[
Get the root directory for the LSP.

Accounts for Octo buffers which we don't really want the LSP to start on.
]]
---@param markers (string|string[])[] list of markers that we watch for
---@return function root_dir_callback a callback for `root_dirs`
M.root_dir_fn = function(markers)
  local final_markers = default_markers

  if (markers) then
    final_markers = markers
  end

  return function(bufnr, on_dir)
    if vim.api.nvim_buf_get_name(bufnr):match("^octo://") then
      return
    end

    local root = vim.fs.root(bufnr, final_markers)
    if root then
      on_dir(root)
    end
  end
end

return M
