## Create scratch file

Create temporary playground files effortlessly. Find them later without worrying about filenames or locations.

## Install & Config

```lua
-- use lazy.nvim
{
  "AgatZan/scratch.nvim",
  branch = "mini"
}
```

<details>
<summary>Detailed Configuration</summary>

```lua
return {
    "AgatZan/scratch.nvim",
    branch = "mini",
    dependencies = {
        {"nvim-telescope/telescope.nvim"}, -- optional: if you want to pick scratch file by telescope
    },
    opts = {
        base_dir = vim.fn.stdpath("cache") .. "/scratch.nvim", -- where your scratch files will be put
        win_config = {} -- default |:h nvim_open_win()| {config}
        filetypes = { "lua", "js", "sh", "ts", "MANUAL_TEXT" }, -- you can simply put filetype here. NOTE: last always manual
        filetype_details = { -- or, you can have more control here
            ["file_type"] = {
                content = {"first line", "second"},
                cursor = {
                    location = {0,0}, -- index to place cursor
                    insert_mode = true, -- in insert mode?
                }, 
                win_config = {} -- |:h nvim_open_win()| {config}
                generator = function(base_dir, filetype) return "something" end
            },
        },
    },
}
```

### Modify config at runtime, no need to restart nvim

To check your current configuration, simply type `:lua = vim.g.scratch_config`

And if you want to modify the config, for example add a new filetype, just call the `setup` function with your updated config again.

Change the `vim.g.scratch_config` global variable directly bad decision because if u change `base_dir` then u must worry about it exist

</details>

## Commands & Keymapps

All commands are started with `Scratch`, and no default keymappings.

| Command           | Description                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| `Scratch`         | Creates a new scratch file in the specified `base_dir` directory in your configuration.         |
| `ScratchOpen`     | Opens an existing scratch file from the `base_dir`. **USING `telescope.nvim`**                                            |

Keybinding recommendation:

```lua
vim.keymap.set("n", "<leader><leader>", "<cmd>Scratch<cr>")
vim.keymap.set("n", "<leader>fs", "<cmd>ScratchOpen<cr>", {desc = "[F]ind [S]cratch"})
```

## CREDITS
- [@LintaoAmons](https://github.com/LintaoAmons) for making [scratch.nvim](https://github.com/LintaoAmons)

