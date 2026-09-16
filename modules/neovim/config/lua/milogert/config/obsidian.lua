local u = require("milogert.utils")

local fidget = require("fidget")

local vaults = {
  Personal = {
    path = "~/Obsidian/Personal",
    livesync_db = "~/.local/share/obsidian-livesync/Personal",
  },
}

local workspace_path = function(path)
  local expanded = vim.fn.expand(path)

  if vim.fn.isdirectory(expanded) == 1 then
    return expanded
  end

  return vim.uv.cwd()
end

require("obsidian").setup({
  workspaces = {
    {
      name = "Personal",
      path = function()
        return workspace_path(vaults.Personal.path)
      end,
    },
  },

  -- Remove this eventually.
  legacy_commands = false,
})

local obsidian_augroup =
  vim.api.nvim_create_augroup("obsidian", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = obsidian_augroup,
  pattern = "ObsidianNoteEnter",
  callback = function(_ev)
    vim.opt_local.conceallevel = 1
  end,
})

local notify = function(message, level)
  if fidget then
    fidget.notify(message, level)
  else
    vim.notify(
      message,
      level or vim.log.levels.INFO,
      { title = "Obsidian LiveSync" }
    )
  end
end

local normalize_path = function(path)
  return vim.fs.normalize(vim.fn.fnamemodify(vim.fn.expand(path), ":p"))
end

local normalize_dir = function(path)
  return normalize_path(path):gsub("/$", "")
end

local is_file_in_dir = function(file_path, dir_path)
  local file = normalize_path(file_path)
  local dir = normalize_dir(dir_path)

  return file == dir or file:sub(1, #dir + 1) == dir .. "/"
end

local is_obsidian_vault = function(path)
  return vim.fn.isdirectory(normalize_dir(path) .. "/.obsidian") == 1
end

local current_vault = function(bufnr)
  local current_file = vim.api.nvim_buf_get_name(bufnr or 0)
  if current_file == "" then
    return nil, nil, nil, current_file
  end

  for name, vault in pairs(vaults) do
    local vault_path = normalize_dir(vault.path)

    if
      is_obsidian_vault(vault_path) and is_file_in_dir(current_file, vault_path)
    then
      return name, vault, vault_path, normalize_path(current_file)
    end
  end

  return nil, nil, nil, current_file
end

local vault_relative_path = function(vault_path, file_path)
  return normalize_path(file_path):sub(#normalize_dir(vault_path) + 2)
end

local livesync_cli = function()
  local variables = require("milogert.variables").get() or {}
  return variables.obsidian and variables.obsidian.livesync_cli
    or "livesync-cli"
end

local run_livesync = function(args, opts)
  opts = opts or {}

  local output = {}
  local command = vim.list_extend({ livesync_cli() }, args)

  local job = vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        local message = table.concat(
          vim.tbl_filter(function(line)
            return line ~= ""
          end, output),
          "\n"
        )
        notify(
          (opts.failure_message or "command failed")
            .. " (exit "
            .. code
            .. ")"
            .. (message ~= "" and "\n" .. message or ""),
          vim.log.levels.ERROR
        )
        return
      end

      if opts.on_success then
        opts.on_success()
      elseif opts.success_message then
        notify(opts.success_message)
      end
    end,
  })

  if job <= 0 then
    notify("failed to start livesync-cli", vim.log.levels.ERROR)
  end
end

local db_path = function(vault)
  local path = vim.fn.fnamemodify(vim.fn.expand(vault.livesync_db), ":p")
  vim.fn.mkdir(path, "p")
  return path
end

local push_current = function(bufnr, opts)
  opts = opts or {}

  local name, vault, vault_path, file_path = current_vault(bufnr)
  if not vault then
    if not opts.silent then
      notify(
        "current file is not inside a configured vault",
        vim.log.levels.WARN
      )
    end
    return
  end

  local relative_path = vault_relative_path(vault_path, file_path)
  if relative_path == "" or vim.fn.filereadable(file_path) ~= 1 then
    return
  end

  run_livesync({ db_path(vault), "push", file_path, relative_path }, {
    failure_message = "push failed for " .. relative_path,
    on_success = function()
      if opts.sync == false then
        notify("pushed " .. relative_path .. " to " .. name)
        return
      end

      run_livesync({ db_path(vault), "sync" }, {
        success_message = "pushed and synced "
          .. relative_path
          .. " to "
          .. name,
        failure_message = "sync failed after pushing " .. relative_path,
      })
    end,
  })
end

local pull_current = function(bufnr)
  local target_bufnr = bufnr and bufnr > 0 and bufnr
    or vim.api.nvim_get_current_buf()

  if vim.bo[target_bufnr].modified then
    notify("buffer has unsaved changes; refusing to pull", vim.log.levels.WARN)
    return
  end

  local name, vault, vault_path, file_path = current_vault(target_bufnr)
  if not vault then
    notify("current file is not inside a configured vault", vim.log.levels.WARN)
    return
  end

  local relative_path = vault_relative_path(vault_path, file_path)
  run_livesync({ db_path(vault), "sync" }, {
    failure_message = "sync failed before pulling " .. relative_path,
    on_success = function()
      run_livesync({ db_path(vault), "pull", relative_path, file_path }, {
        success_message = "pulled and synced "
          .. relative_path
          .. " from "
          .. name,
        failure_message = "pull failed for " .. relative_path,
        on_success = function()
          if vim.api.nvim_buf_is_valid(target_bufnr) then
            vim.cmd("checktime " .. target_bufnr)
          end
          notify("pulled and synced " .. relative_path .. " from " .. name)
        end,
      })
    end,
  })
end

local sync_current = function(bufnr)
  local name, vault = current_vault(bufnr or 0)
  if not vault then
    notify("current file is not inside a configured vault", vim.log.levels.WARN)
    return
  end

  run_livesync({ db_path(vault), "sync" }, {
    success_message = "synced " .. name,
    failure_message = "sync failed for " .. name,
  })
end

local livesync_commands = {
  push = function()
    push_current(vim.api.nvim_get_current_buf())
  end,
  pull = function()
    pull_current(vim.api.nvim_get_current_buf())
  end,
  sync = function()
    sync_current(vim.api.nvim_get_current_buf())
  end,
}

vim.api.nvim_create_user_command("ObsidianLiveSync", function(opts)
  local command = opts.fargs[1]
  local callback = livesync_commands[command]

  if not callback then
    notify(
      "unknown command: "
        .. (command or "")
        .. " (expected "
        .. table.concat(vim.tbl_keys(livesync_commands), ", ")
        .. ")",
      vim.log.levels.ERROR
    )
    return
  end

  callback()
end, {
  nargs = 1,
  complete = function(arglead)
    return vim.tbl_filter(function(command)
      return command:find(arglead, 1, true) == 1
    end, vim.tbl_keys(livesync_commands))
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = obsidian_augroup,
  callback = function(ev)
    if current_vault(ev.buf) then
      push_current(ev.buf, { silent = true })
    end
  end,
})
