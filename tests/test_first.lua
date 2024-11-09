local function escape(s)
	return vim.api.nvim_replace_termcodes(s, true, true, true)
end
-- H.keys = {
-- 	above =  escape('<C-o>O'),
-- 	bs = escape('<bs>'),
-- 	cr = escape('<cr>'),
-- 	del = escape('<del>'),
-- 	keep_undo = escape('<C-g>U'),
-- 	-- NOTE: use `get_arrow_key()` instead of `H.keys.left` or `H.keys.right`
-- 	left = escape("<left>"),
-- 	right = escape("<right>"),
-- }

local T = MiniTest.new_set({
      parametrize = { 
      { "<C-o>O", escape('<C-o>O') }, {'<bs>', escape('<bs>') }, {'<cr>', escape('<cr>') }, {'<C-g>U',escape('<C-g>U')}, {"<left>", escape("<left>")}, {"<right>",escape("<right>")} 
    },
})

T["works"] = function(key, term)
    MiniTest.add_note("|".. key..">--- " .. term)
end

return T
