## Create scratch file

Create temporary playground files effortlessly. Find them later without worrying about filenames or locations.

## Install & Config

```lua
-- use lazy.nvim
vim.g.os_sep = '/' -- your os directory separator
return {
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
        --NOTE: base_dir must end with OS directory separator(`"/" "\\"`)
        base_dir = vim.fn.stdpath("cache") .. vim.g.os_sep .. "scratch.nvim" .. vim.g.os_sep, -- where your scratch files will be put.
        win_config = {} -- default |:h nvim_open_win()| {config}
        choices = { "lua", "js", "sh", "ts", "MANUAL_TEXT" }, -- trigger as default filetype. NOTE: last always manual
        choice_details = { -- or, you can have more control here
            ["choice"] = {
                ft = "txt", -- :see `filetypes`
                win_config = {} -- |:h nvim_open_win()| {config}
                content = {"first line", "second line"} -- default text
                generator = function(base_dir) return "something" end
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

## API

`require("scratch.api")`
`detail` := {
    ft:string, 
    win_config:vim.api.keyset.win_config, 
    generator: fun(base_dir:string):string
}
| Function        | Prototype       | Description |
| --------------  | --------------- | ----------- |
| `scratch`   | `fun(scratch_dir:string, ft:string, opts:detail)`        | Create empty buffer at result of `opts.generator(scratch_dir)` and open it by `opts.win_config` or replace current if `{}` |
| `ft_input`  | `fun(scratch_dir:string, opts:detail)`                   | Input filetype and create buffer with it like filetype |
| `ft_select` | `fun(scratch_dir:string, choices:string[], opts:detail)` | Select filetype from given choice |
## CREDITS
- [@LintaoAmons](https://github.com/LintaoAmons) for making [scratch.nvim](https://github.com/LintaoAmons)

