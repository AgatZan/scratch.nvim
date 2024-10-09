local M = {}

---@param dir string
---@param ft string
---@param opts Scratch.FiletypeDetail
function M.scratch(dir, ft, opts)
	local abs_path = (opts.generator or function(base_dir, fit)
		return base_dir .. os.date("%y-%m-%d_%H-%M-%S") .. "." .. fit
	end)(dir, ft)

	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(buf, abs_path)
	local filetype = opts.ft or ft
	vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })

	-- win_config == {}
	if next(opts.win_config) == nil then
		vim.api.nvim_set_current_buf(buf)
	else
		vim.api.nvim_open_win(buf, true, opts.win_config)
	end
	if opts.content then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.content)
	end
end

---@param scratch_file_dir string
---@param opts {[1]:vim.api.keyset.win_config, [string]:Scratch.FiletypeDetail}
function M.ft_input(scratch_file_dir, opts)
	vim.ui.input({ prompt = "Inter filetype: " }, function(choice)
		if choice ~= nil then
			return M.scratch(scratch_file_dir, choice, opts[
				choice --[[@as string]]
			] or { win_config = opts[1] })
		end
		vim.notify("No filetype", vim.log.levels.INFO)
	end)
end

---simple input name
---@param scratch_file_dir string
---@param filetypes string[]
---@param opts Scratch.FiletypeDetail
function M.ft_select(scratch_file_dir, filetypes, opts)
	vim.ui.select(filetypes, {
		prompt = "Enter the file type: ",
	}, function(ft)
		if ft ~= nil and ft ~= "" then
			if ft == filetypes[#filetypes] then
				vim.ui.input(
					{ prompt = "Inter filetype: ", default = "txt" },
					function(choice)
						if choice ~= nil then
							return M.scratch(scratch_file_dir, choice, opts)
						end
					end
				)
			else
				return M.scratch(scratch_file_dir, ft, opts)
			end
		end
		vim.notify("No file")
	end)
end

return M
