local M = {}

local action_state = require("telescope.actions.state")

function M.delete_item(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	picker:delete_selection(function(s)
		local file_name = s[1]
		-- INFO: currently just protect configFilePath from being removed
		if file_name == "configFilePath" then
			vim.notify(
				"[scratch.nvim] configFilePath cannot be removed",
				vim.log.levels.WARN
			)
			return false
		end
		local suc, err = vim.uv.fs_rmdir(s.cmd .. vim.g.os_sep .. s[1])
		if not suc then
			vim.notify(
				err or "",
				vim.log.levels.ERROR,
				{ title = "scratch.nvim" }
			)
			return false
		end
		return true
	end)
end

return M
