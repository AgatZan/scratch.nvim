local M = {}

---@param base_dir string path to scandir
function M.findByTelescope(base_dir)
	local telescope_status, telescope_builtin =
		pcall(require, "telescope.builtin")
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
			return true
		end,
	})
end

---@param base_dir string
function M.findByTelescopeGrep(base_dir)
	local _, telescope_builtin = pcall(require, "telescope.builtin")
	telescope_builtin.live_grep({
		cwd = base_dir,
	})
end

return M
