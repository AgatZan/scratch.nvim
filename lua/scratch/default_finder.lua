local M = {}

---@param base_dir string path to scandir
function M.findByTelescope(base_dir)
	local telescope_builtin = require("telescope.builtin")

	telescope_builtin.find_files({
		cwd = base_dir,
	})
end

---@param base_dir string
function M.findByTelescopeGrep(base_dir)
	local telescope_builtin = require("telescope.builtin")
	telescope_builtin.live_grep({
		cwd = base_dir,
	})
end

return M
