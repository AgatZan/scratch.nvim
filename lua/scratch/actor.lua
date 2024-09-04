local utils = require("scratch.utils")

---@class Scratch.Actor
---@field base_dir string
---@field win_config vim.api.keyset.win_config @see: nvim_open_win() {config}
---@field filetypes string[]
---@field manual_text string
---@field filetype_details Scratch.FiletypeDetails
---@field localKeys Scratch.LocalKeyConfig[]
local M = {}

---@param filename string
---@param win_conf? vim.api.keyset.win_config
---@param content? string[]
---@param local_keys? Scratch.LocalKeyConfig
---@param cursor? Scratch.Cursor
function M:scratchByName(filename, win_conf, content, local_keys, cursor)
  local abs_path = self.base_dir .. filename
  local fto = {}
  for i in filename:gmatch("([^%.]+)") do
    table.insert(fto, i)
  end
  local ft = fto[#fto]
  content = content or self.filetype_details[ft] and self.filetype_details[ft].content
  cursor = cursor or self.filetype_details[ft] and self.filetype_details[ft].cursor
  utils.scratch(abs_path, win_conf or self.win_config, content, local_keys, cursor)
end

---@param ft string
---@param win_conf? vim.api.keyset.win_config
---@param content? string[]
function M:scratchByType(ft, win_conf, content, local_keys, cursor)
  local abs_path = self.base_dir .. utils.get_abs_path(ft)
  content = content or self.filetype_details[ft] and self.filetype_details[ft].content
  cursor = cursor or self.filetype_details[ft] and self.filetype_details[ft].cursor
  utils.scratch(abs_path, win_conf or self.win_config, content, local_keys, cursor)
end

---@return string[]
function M:get_all_filetypes()
  local combined_filetypes = {}
  local cash = {}
  for _, ft in ipairs(self.filetypes or {}) do
    if not cash[ft] then
      table.insert(combined_filetypes, ft)
      cash[ft] = 1
    end
  end
  for ft, _ in pairs(self.filetype_details or {}) do
    if not cash[ft] then
      table.insert(combined_filetypes, ft)
      cash[ft] = 1
    end
  end

  table.insert(combined_filetypes, self.manual_text)
  return combined_filetypes
end

---choose ft by using selector function
---@param selector_filetype fun(filetypes:string[]):string think about last element like about MANUAL or like u prefers
---@param win_conf? vim.api.keyset.win_config
---@param content?  string[]
---@param local_keys? Scratch.LocalKeyConfig
---@param cursor? Scratch.Cursor
function M:scratchWithSelectorFT(selector_filetype, win_conf, content, local_keys, cursor)
  local filetypes = self:get_all_filetypes()
  coroutine.wrap(function()
    local ft = selector_filetype(filetypes)
    self:scratchByType(ft, win_conf, content, local_keys, cursor)
  end)()
end

---choose ft by using selector function
---@param input_filename fun():string input filename
---@param win_conf? vim.api.keyset.win_config
---@param content?  string[]
---@param local_keys? Scratch.LocalKeyConfig
---@param cursor? Scratch.Cursor
function M:scratchWithInputFN(input_filename, win_conf, content, local_keys, cursor)
  coroutine.wrap(function()
    local filename = input_filename()
    self:scratchByName(filename, win_conf, content, local_keys, cursor)
  end)()
end

---simple input name
---@param win_conf? vim.api.keyset.win_config
---@param content?  string[]
---@param local_keys? Scratch.LocalKeyConfig
---@param cursor? Scratch.Cursor
function M:scratchWithName(win_conf, content, local_keys, cursor)
  vim.ui.input({
    prompt = "Enter the file name: ",
  }, function(filename)
    if filename ~= nil and filename ~= "" then
      return self:scratchByName(filename, win_conf, content, local_keys, cursor)
    end
    vim.notify("No file")
  end)
end

-- ---@param opts Scratch.LocalKey[]
-- function M:scratchOpen(opts)
-- 	if self.file_picker == "telescope" then
-- 		self:open_scratch_telescope(opts)
-- 	elseif self.file_picker == "fzflua" then
-- 		self:open_scratch_fzflua()
-- 	else
-- 		self:open_scratch_vim_ui()
-- 	end
-- end
return M