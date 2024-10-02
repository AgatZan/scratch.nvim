local M = {}

---@return string[]
function M.getSelectedText()
	local sv = vim.fn.getpos("'<")
	local ev = vim.fn.getpos("'>")
	local lines = vim.fn.getline(sv[2], ev[2]) ---@cast lines string[]
	-- local lines = vim.api.nvim_buf_get_lines(0, sv[2] - 1, ev[2], false)
	local n = #lines
	if n == 0 then
		return {}
	end
	lines[n] = string.sub(lines[n], 1, sv[3])
	lines[1] = string.sub(lines[1], ev[3])
	return lines
end

---@param scratch_file_dir string
---@param ft string
---@param opts Scratch.FiletypeDetail
function M.scratchByType(scratch_file_dir, ft, opts)
	local abs_path = (opts.generator or function(base_dir, fit)
		return base_dir .. os.date("%y-%m-%d_%H-%M-%S") .. "." .. fit
	end)(scratch_file_dir, ft)

	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(buf, abs_path)
	local filetype = vim.filetype.match({ filename = abs_path })
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

function M.scratchFromInput(scratch_file_dir, opts)
	vim.ui.input({ prompt = "Inter filetype: " }, function(choice)
		if choice ~= nil then
			return M.scratchByType(scratch_file_dir, choice, opts)
		end
		vim.notify("No filetype", vim.log.levels.INFO)
	end)
end
---simple input name
---@param scratch_file_dir string
---@param filetypes string[]
---@param opts Scratch.FiletypeDetail
function M.scratchWithFt(scratch_file_dir, filetypes, opts)
	vim.ui.select(filetypes, {
		prompt = "Enter the file type: ",
	}, function(ft)
		if ft ~= nil and ft ~= "" then
			if ft == filetypes[#filetypes] then
				vim.ui.input(
					{ prompt = "Inter filetype: ", default = "txt" },
					function(choice)
						if choice ~= nil then
							return M.scratchByType(
								scratch_file_dir,
								choice,
								opts
							)
						end
					end
				)
			else
				return M.scratchByType(scratch_file_dir, ft, opts)
			end
		end
		vim.notify("No file")
	end)
end

return M
