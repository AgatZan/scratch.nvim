if vim.g.scratch_load then
	return
end
local function get_selected(mode)
	return vim.fn.getregion(
		vim.fn.getpos("v"),
		vim.fn.getpos("."),
		{ type = mode }
	)
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

vim.api.nvim_create_user_command("Scratch", function()
	local fts = vim.g.scratch_config.choices
	local scratch_file_dir = vim.g.scratch_config.base_dir --[[@as string]]
	local opts = { win_config = vim.g.scratch_config.win_config }
	local mode = vim.api.nvim_get_mode().mode
	if mode ~= "n" then
		opts.content = get_selected(mode)
		-- elseif args.range > 0 then
		-- 	opts.content = get_selected("'>")
	end
	api.ft_select(scratch_file_dir, fts, opts)
end, { range = true })

vim.api.nvim_create_user_command("ScratchOpen", function()
	require("scratch.default_finder").findByTelescope(
		vim.g.scratch_config.base_dir
	)
end, {})
