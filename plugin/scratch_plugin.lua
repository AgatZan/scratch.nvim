if vim.g.scratch_load then
	return
end
local function get_selected()
	local sv = vim.fn.getpos("'<")
	local ev = vim.fn.getpos("'>")
	local lines = vim.fn.getline(sv[2], ev[2]) ---@cast lines string[]
	local n = #lines
	if n == 0 then
		return {}
	end
	lines[n] = string.sub(lines[n], 1, sv[3])
	lines[1] = string.sub(lines[1], ev[3])
	return lines
end

vim.g.scratch_load = true

local base_path = vim.fn.stdpath("cache")
	.. vim.g.os_sep
	.. "scratch.nvim"
	.. vim.g.os_sep

vim.g.scratch_config = { ---@type Scratch.ActorConfig
	base_dir = base_path,
	choices = { "lua", "js", "py", "sh", "MANUAL INPUT" }, -- Last means manual
	win_config = {},
	choice_details = {},
}
local api = require("scratch.api")

vim.api.nvim_create_user_command("Scratch", function(args)
	local fts = vim.g.scratch_config.choices
	local scratch_file_dir = vim.g.scratch_config.base_dir --[[@as string]]
	if args.range > 0 then
		api.ft_select(scratch_file_dir, fts, {
			ft = "",
			content = get_selected(),
			win_config = vim.g.scratch_config.win_config,
		})
	else
		api.ft_select(
			scratch_file_dir,
			fts,
			{ ft = "", win_config = vim.g.scratch_config.win_config }
		)
	end
end, { range = true })

vim.api.nvim_create_user_command("ScratchOpen", function()
	require("scratch.default_finder").findByTelescope(
		vim.g.scratch_config.base_dir
	)
end, {})
