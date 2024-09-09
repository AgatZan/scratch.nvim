if vim.g.scratch_load then
	return
end
vim.g.scratch_load = true

local base_path = vim.fn.stdpath("cache")
	.. vim.g.os_sep
	.. "scratch.nvim"
	.. vim.g.os_sep
vim.g.scratch_config = { ---@type Scratch.ActorConfig
	scratch_file_dir = base_path, -- where your scratch files will be put
	filetypes = { "lua", "js", "py", "sh" }, -- you can simply put filetype here
	win_config = {
		relative = "editor", -- Assuming you want the floating window relative to the editor
		row = 2,
		col = 5,
		width = vim.api.nvim_win_get_width(0) - 10, -- Get the screen width - row * col
		--api_get_option("lines") - 5,
		height = vim.api.nvim_win_get_height(0) - 5, -- Get the screen height - col
		style = "minimal",
		border = "single",
		title = "",
	},
	filetype_details = {},
	localKeys = {},
	manual_text = "MANUAL_INPUT",
}
local api = require("scratch.api")
local utils = require("scratch.utils")

vim.api.nvim_create_user_command("Scratch", function(args)
	local fts = vim.g.scratch_config.filetypes
	local scratch_file_dir = vim.g.scratch_config.scratch_file_dir
	if args.range > 0 then
		api.scratchWithFt(
			scratch_file_dir,
			fts,
			{ content = utils.getSelectedText() }
		)
	else
		api.scratchWithFt(scratch_file_dir, fts)
	end
end, { range = true })

vim.api.nvim_create_user_command("ScratchOpen", function()
	require("scratch.default_finder").findByTelescope(
		vim.g.scratch_config.scratch_file_dir
	)
end, {})
