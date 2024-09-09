local M = {}
---@class Scratch.FiletypeDetail
---@field content? string[]
---@field cursor? Scratch.Cursor

---@alias Scratch.FiletypeDetails { [string]:Scratch.FiletypeDetail }

---@class Scratch.Cursor
---@field location number[]
---@field insert_mode boolean

---@class Scratch.ActorConfig
---@field scratch_file_dir string
---@field filetypes string[]
---@field win_config vim.api.keyset.win_config @see nvim_open_window
---@field filetype_details Scratch.FiletypeDetails
---@field manual_text string

---@class Scratch.Config
---@field scratch_file_dir? string
---@field filetypes? string[]
---@field win_config? vim.api.keyset.win_config @see nvim_open_window
---@field filetype_details? Scratch.FiletypeDetails
---@field manual_text? string

---@param user_config Scratch.Config
---@return Scratch.ActorConfig
function M.setup(user_config)
	if next(user_config) == nil then
		return vim.g.scratch_config
	end
	vim.g.scratch_config =
		vim.tbl_deep_extend("force", vim.g.scratch_config, user_config)
	vim.g.scratch_config.win_config = user_config.win_config
		or vim.g.scratch_config.win_config
	if
		vim.g.scratch_config.scratch_file_dir
		and not vim.uv.fs_stat(vim.g.scratch_config.scratch_file_dir).type
			== "directory"
	then
		vim.uv.fs_mkdir(vim.g.scratch_config.scratch_file_dir, 666)
	end
	return vim.g.scratch_config
end

return M
