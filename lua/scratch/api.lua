local M = {}

---@param scratch_file_dir string
---@param ft string
---@param opts? Scratch.FiletypeDetail
function M.scratchByType(scratch_file_dir, ft, opts)
	opts = opts or {}

	local abs_path = (opts.generator or function(base_dir, fit)
		return base_dir .. os.date("%y-%m-%d_%H-%M-%S") .. "." .. fit
	end)(scratch_file_dir, ft)

	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(buf, abs_path)

	-- win_config == {}
	if next(opts.win_config) == nil then
		vim.api.nvim_set_current_buf(buf)
	else
		vim.api.nvim_open_win(buf, true, opts.win_config)
	end
	-- TODO: remove when remade templater
	if opts.content then
		local bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, opts.content)
	end
	if opts.cursor then
		M.put_cursor(opts.cursor)
	end
end

---simple input name
---@param scratch_file_dir string
---@param filetypes string[]
---@param opts? Scratch.FiletypeDetail
function M.scratchWithFt(scratch_file_dir, filetypes, opts)
	vim.ui.select(filetypes, {
		prompt = "Enter the file type: ",
	}, function(ft)
		if ft ~= nil and ft ~= "" then
			return M.scratchByType(scratch_file_dir, ft, opts)
		end
		vim.notify("No file")
	end)
end

return M
