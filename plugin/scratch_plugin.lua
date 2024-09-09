if vim.g.scratch_load then
	return
end
vim.g.scratch_load = true

local base_path = vim.fn.stdpath("cache")
	.. vim.g.os_sep
	.. "scratch.nvim"
	.. vim.g.os_sep
vim.g.scratch_config = { ---@type Scratch.ActorConfig
	base_dir = base_path,
	filetypes = { "lua", "js", "py", "sh", "MANUAL INPUT" }, -- Last means manual
	win_config = {},
	filetype_details = {},
}
local api = require("scratch.api")

vim.api.nvim_create_user_command("Scratch", function(args)
	local fts = vim.g.scratch_config.filetypes
	local scratch_file_dir = vim.g.scratch_config.base_dir
	if args.range > 0 then
		api.scratchWithFt(scratch_file_dir, fts, {
			content = api.getSelectedText(),
			win_config = vim.g.scratch_config.win_config,
		})
	else
		api.scratchWithFt(
			scratch_file_dir,
			fts,
			{ win_config = vim.g.scratch_config.win_config }
		)
	end
end, { range = true })

vim.api.nvim_create_user_command("ScratchOpen", function()
	require("scratch.default_finder").findByTelescope(
		vim.g.scratch_config.base_dir
	)
end, {})
