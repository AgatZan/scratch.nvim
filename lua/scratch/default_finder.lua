local M = {}

---@param base_dir string path to scandir
---@param sorter? fun(file_a:string, file_b:string):boolean @see: table.sort
---@param win_conf? vim.api.keyset.win_config
---@param local_keys? Scratch.LocalKeyConfig
function M.findByNative(base_dir, sorter, win_conf, local_keys)
  local utils = require("scratch.utils")
  local scratch_file_dir = base_dir
  local abs_filenames = utils.scandir(scratch_file_dir)
  if sorter then
    table.sort(abs_filenames, sorter)
  end
  -- sort the files by their last modified time in descending order
  -- Why?
  -- table.sort(files, function(a, b)
  -- 	return vim.fn.getftime(scratch_file_dir .. vim.g.os_sep .. a)
  -- 		> vim.fn.getftime(scratch_file_dir .. vim.g.os_sep .. b)
  -- end)

  vim.ui.select(abs_filenames, {
    prompt = "Select old scratch files",
    format_item = function(item)
      return item
    end,
  }, function(chosenFile)
    if chosenFile then
      utils.open_(chosenFile, win_conf)
      if local_keys then
        utils.register_local_key(local_keys)
      end
    end
  end)
end

---@param base_dir string path to scandir
function M.findByFzf(base_dir)
  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    return vim.notify(
      "Can't find fzf-lua, please check your configuration",
      vim.log.levels.ERROR,
      { title = "scratch.nvim" }
    )
  end

  if vim.fn.executable("rg") ~= 1 then
    return vim.notify(
      "Can't find fzf-lua, please check your configuration",
      vim.log.levels.ERROR,
      { title = "scratch.nvim" }
    )
  end
  fzf_lua.files({ cmd = "rg --files --sortr modified " .. base_dir })
end

---@param base_dir string path to scandir
---@param local_keys Scratch.LocalKey[]
function M.findByTelescope(base_dir, local_keys)
  local telescope_status, telescope_builtin = pcall(require, "telescope.builtin")
  if not telescope_status then
    vim.notify(
      'ScrachOpen needs telescope.nvim or you can just add `"use_telescope: false"` into your config file ot use native select ui'
    )
    return
  end

  telescope_builtin.find_files({
    cwd = base_dir,
    attach_mappings = function(prompt_bufnr, map)
      map("n", "dd", function()
        require("scratch.telescope_actions").delete_item(prompt_bufnr)
      end)
      -- TODO: user can customise keybinding
      for _, key in ipairs(local_keys) do
        map(key.modes, key.key, key.cmd)
      end
      return true
    end,
  })
end

---@param base_dir string
function M.findByTelescopeGrep(base_dir)
  local telescope_status, telescope_builtin = pcall(require, "telescope.builtin")
  if not telescope_status then
    return vim.notify("ScrachOpenFzf needs telescope.nvim")
  end
  telescope_builtin.live_grep({
    cwd = base_dir,
  })
end

return M