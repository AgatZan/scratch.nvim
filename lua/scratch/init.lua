local M = {}

---@param user_config? Scratch.ActorConfig
---@return Scratch.ActorConfig
function M.setup(user_config)
  if user_config == nil then
    return vim.g.scratch_config
  end
  vim.g.scratch_config = vim.tbl_deep_extend("force", vim.g.scratch_config, user_config)
  vim.g.scratch_config.win_config = user_config.win_config or vim.g.scratch_config.win_config
  if
    vim.g.scratch_config.scratch_file_dir
    and not vim.uv.fs_stat(vim.g.scratch_config.scratch_file_dir).type == "directory"
  then
    vim.uv.fs_mkdir(vim.g.scratch_config.scratch_file_dir, 666)
  end
  return vim.g.scratch_config
end

return M
