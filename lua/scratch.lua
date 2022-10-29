local config = require("config")
local M = {}

M.initDir = function()
	if vim.fn.isdirectory(config.scratch_file_dir) == 0 then
		vim.fn.mkdir(config.scratch_file_dir, "p")
		vim.notify(config.scratch_file_dir .. " created")
	else
		vim.notify(config.scratch_file_dir .. " already exists")
	end
end

local function createOrOpenFile(ft)
	local datetime = string.gsub(vim.fn.system("date +'%Y%m%d-%H%M%S'"), "\n", "")
	local filename = M.scratch_file_dir .. "/" .. datetime .. "." .. ft
	vim.cmd(":e " .. filename)
end

local function selectFiletypeAndDo(func)
	vim.ui.select(config.filetypes, {
		prompt = "Select filetype",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		func(choice)
	end)
end

M.createOrOpenScratchFile = function()
	selectFiletypeAndDo(createOrOpenFile)
end

return M
