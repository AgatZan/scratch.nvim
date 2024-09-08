<<<<<<< HEAD
local utils = require("scratch.utils")
-- make sure this file is loaded only once
if vim.g.loaded_scratch == 1 then
  return
end
vim.g.loaded_scratch = 1
vim.g.os_sep = vim.g.os_sep or vim.fn.has("win32") and "\\" or "/"

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!

-- TODO: remove those requires

local base_path = vim.fn.stdpath("cache") .. vim.g.os_sep .. "scratch.nvim" .. vim.g.os_sep

local Actor = require("scratch.actor")
---@type Scratch.Actor
vim.g.scratch_actor = vim.g.scratch_actor
  or setmetatable({
    base_dir = base_path, -- where your scratch files will be put
    filetypes = { "lua", "js", "py", "sh" }, -- you can simply put filetype here
    window = {
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
    file_picker = "fzflua",
    filetype_details = {},
    localKeys = {},
    manual_text = "MANUAL_INPUT",
  }, Actor)

vim.api.nvim_create_user_command("Scratch", function(args)
  if args.range > 0 then
    vim.g.scratch_actor:scratch({ content = utils.getSelectedText() })
  else
    vim.g.scratch_actor:scratch({})
=======
if vim.g.scratch_load then
  return
end
vim.g.scratch_load = true
vim.g.os_sep = vim.g.os_sep or vim.uv.os_uname().sysname == "Windows_NT" and "\\" or "/"

vim.g.scratch_config = require("scratch.config") ---@type Scratch.ActorConfig

local api = require("scratch.api")
local utils = require("scratch.utils")

vim.api.nvim_create_user_command("Scratch", function(args)
  local fts = vim.g.scratch_config.filetypes
  local scratch_file_dir = vim.g.scratch_config.scratch_file_dir
  if args.range > 0 then
    api.scratchWithFt(scratch_file_dir, fts, { content = utils.getSelectedText() })
  else
    api.scratchWithFt(scratch_file_dir, fts)
>>>>>>> 45915ac (refactor(config): move default setup to `plugin/`  move default config to `scratch/config.lua`)
  end
end, { range = true })

vim.api.nvim_create_user_command("ScratchOpen", function()
<<<<<<< HEAD
  vim.g.scratch_actor:scratchOpen({})
end, {})
vim.api.nvim_create_user_command("ScratchOpenFzf", function()
  vim.g.scratch_actor:fzfScratch()
end, {})
vim.api.nvim_create_user_command("ScratchWithName", function()
  vim.g.scratch_actor:scratchWithName()
=======
  require("scratch.default_finder").findByNative(vim.g.scratch_config.scratch_file_dir)
end, {})

vim.api.nvim_create_user_command("ScratchOpenTelescope", function()
  require("scratch.default_finder").findByTelescope(vim.g.scratch_config.scratch_file_dir)
end, {})

vim.api.nvim_create_user_command("ScratchOpenTelescopeGrep", function()
  require("scratch.default_finder").findByTelescopeGrep(vim.g.scratch_config.scratch_file_dir)
end, {})

vim.api.nvim_create_user_command("ScratchWithName", function()
  api.scratchWithName(vim.g.scratch_config.scratch_file_dir)
>>>>>>> 45915ac (refactor(config): move default setup to `plugin/`  move default config to `scratch/config.lua`)
end, {})
