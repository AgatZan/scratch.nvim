local M = {}

local action_state = require("telescope.actions.state")

function M.delete_item(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	picker:delete_selection(function(s)
		local f = io.open("text.txt", "w")
		if f then
			f:write(vim.inspect(s))
			f:close()
		end
		local file_name = s[1]
		-- INFO: currently just protect configFilePath from being removed
		if file_name == "configFilePath" then
			vim.notify(
				"[scratch.nvim] configFilePath cannot be removed",
				vim.log.levels.WARN
			)
			return false
		end
	end)
end

return M
