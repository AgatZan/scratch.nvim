local M = {}

---@param ft string
---@param base_dir string
---@return string
function M.get_abs_path(base_dir, ft)
	local filename = os.date("%y-%m-%d_%H-%M-%S") .. "." .. ft
	return base_dir .. filename
end

-- Recursively list all files in the specified directory
function M.scandir(directory)
	local files = {}
	local next_dir = { directory }
	repeat
		local current_dir = table.remove(next_dir, 1)
		local fd = vim.uv.fs_scandir(current_dir)
		if fd then
			while true do
				local name, typ = vim.uv.fs_scandir_next(fd)
				if name == nil then
					break
				end
				local entry = current_dir .. name
				if typ == "directory" then
					table.insert(next_dir, entry)
				elseif typ == "file" then
					table.insert(files, entry)
				end
			end
		end
	until #next_dir == 0
	return files
end

--- generate abs filepath
---@param filename string
---@param parentDir string
---@param requiresDir boolean?
---@return string?
function M.genFilepath(filename, parentDir, requiresDir)
	if requiresDir then
		local dirName = parentDir .. vim.g.os_sep .. os.time()
		local suc, err_n, err_m = vim.uv.fs_mkdir(parentDir, 666) -- linux rw_rw_rw_
		if not suc then
			return vim.notify(
				err_n .. ": appear " .. err_m,
				vim.log.levels.ERROR
			)
		end
		return parentDir .. vim.g.os_sep .. dirName .. vim.g.os_sep .. filename
	else
		return parentDir .. vim.g.os_sep .. filename
	end
end

---@return string[]
function M.getSelectedText()
	local sv = vim.fn.getpos("'<")
	local ev = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(0, sv[2] - 1, ev[2], false)
	local n = #lines
	if n == 0 then
		return {}
	end
	lines[n] = string.sub(lines[n], 1, sv[3])
	lines[1] = string.sub(lines[1], ev[3])
	return lines
end

---Make scratch file
---@param abs_path string
---@param win_config vim.api.keyset.win_config
---@param content? string[]
---@param cursor? Scratch.Cursor
function M.scratch(abs_path, win_config, content, cursor)
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(buf, abs_path)
	if next(win_config) == nil then
		vim.api.nvim_set_current_buf(buf)
	else
		vim.api.nvim_open_win(
			buf,
			true,
			win_config --[[@as vim.api.keyset.win_config]]
		)
	end
	if content then
		local bufnr = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
	end
	if cursor then
		M.put_cursor(cursor)
	end
end

return M
