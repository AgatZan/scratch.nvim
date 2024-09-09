-- local a, b = vim.uv.fs_rmdir(
-- 	"F:\\#utils\\nvim-plug\\scratch.nvim\\lua\\scratch\\cache_finder"
-- )
local a, b = os.remove(
	"F:\\#utils\\nvim-plug\\scratch.nvim\\lua\\scratch\\cache_finder"
)
if not a then
	print(b)
end
