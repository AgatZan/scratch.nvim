local M = {}
---@class Scratch.FiletypeDetail
---@field win_config vim.api.keyset.win_config
---@field content? string[]
---@field generator? fun(base_path:string, ft:string): string

---@alias Scratch.FiletypeDetails { [string]:Scratch.FiletypeDetail }

---@class Scratch.ActorConfig
---@field base_dir string
---@field filetypes string[]
---@field filetype_details Scratch.FiletypeDetails
---@field win_config vim.api.keyset.win_config @see nvim_open_window

---@class Scratch.Config
---@field base_dir? string
---@field filetypes? string[]
---@field win_config? vim.api.keyset.win_config @see nvim_open_window
---@field filetype_details? Scratch.FiletypeDetails

---@param user_config Scratch.Config
---@return Scratch.ActorConfig
function M.setup(user_config)
	if next(user_config) == nil then
		return vim.g.scratch_config
	end
	if user_config.base_dir then
		vim.g.scratch_config.base_dir = user_config.base_dir
	end
	if
		not vim.uv.fs_stat(vim.g.scratch_config.base_dir).type == "directory"
	then
		vim.uv.fs_mkdir(vim.g.scratch_config.base_dir, 666)
	end
	if user_config.filetypes then
		vim.g.scratch_config.filetypes = user_config.filetypes
	end
	if user_config.filetype_details then
		vim.g.scratch_config.filetype_details = user_config.filetype_details
	end
	if user_config.win_config then
		vim.g.scratch_config.win_config = user_config.win_config
	end
	return vim.g.scratch_config
end

return M
