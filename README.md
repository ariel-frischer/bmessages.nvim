[<img src="media/nvim.svg" height="60px" align="right" />](https://neovim.io/)

# 💬 Bmessages - Better Neovim Messages

https://github.com/ariel-frischer/bmessages.nvim/assets/19893395/10ae410d-7d0d-4568-9c27-dc7ca6f89137

## ✨ Features

- **Auto-updating Buffers**: `:Bmessages` automatically updates the messages buffer.
- **Customizable Split Types**: Choose between horizontal (`split`) and vertical (`vsplit`) split types for displaying the messages buffer.
- **Resizable Splits**: Easily configure the size of the message buffer split, both for vertical and horizontal layouts.
- **Improved Usability**: The buffer behaves like any standard Neovim buffer, allowing for easier navigation and interaction.
- **Autoscroll Option**: Automatically scroll to the latest message useful when debugging enabled by default.

## 📦 Installation

Add `bmessages` to your Neovim configuration using your preferred package manager.

#### With [lazy.nvim](https://github.com/folke/lazy.nvim)
<details open>
<summary>Click to expand/collapse</summary>

```lua
{
  "ariel-frischer/bmessages.nvim",
  event = "CmdlineEnter",
  opts = {}
}
```
</details>

#### With [packer.nvim](https://github.com/wbthomason/packer.nvim)
<details>
<summary>Click to expand/collapse</summary>

```lua
use({
  "ariel-frischer/bmessages.nvim",
    config = function()
      require("bmessages").setup({
        -- config here or empty for defaults
      })
    end,
  })
```

</details>

#### With [vim-plug](https://github.com/junegunn/vim-plug)

<details>
<summary>Click to expand/collapse</summary>

```vim
Plug 'ariel-frischer/bmessages.nvim'
" ... other plugins...
" after plug#end()
" provide `setup()` configuration options or leave empty for defaults
lua require('bmessages').setup()
```
</details>

#### With [pckr.nvim](https://github.com/lewis6991/pckr.nvim)

<details>
<summary>Click to expand/collapse</summary>

```lua
{ "ariel-frischer/bmessages.nvim",
  config = function()
    require("bmessages").setup({
      -- config here or empty for defaults
    })
  end,
};
```
</details>

### ⚙️  Available Configuration Options

Given options are the default values.
```lua
local opts = {
  -- Time in milliseconds between each update of the messages buffer.
  timer_interval = 1000,
  -- Default split type for the messages buffer ('vsplit' or 'split').
  split_type = "vsplit",
  -- Size of the vertical split when opening the messages buffer.
  split_size_vsplit = nil,
  -- Size of the horizontal split when opening the messages buffer.
  split_size_split = nil,
  -- Automatically scroll to the latest message in the buffer.
  autoscroll = true,
  -- Use a timer to auto-update the messages buffer. When this is disabled,
  -- the buffer will not update, but the buffer becomes modifiable.
  use_timer = true,
  -- Name of the messages buffer.
  buffer_name = "bmessages_buffer",
  -- Don't add user commands for `Bmessages`, `Bmessagesvs`, and `Bmessagessp`.
  disable_create_user_commands = false,
}
```

## 🚀 Usage

### `:Bmessages`

Creates a message buffer with the configured options.

### `:Bmessagesvs`

Creates a message buffer with a vertical split, overriding the `split_type` to `vsplit`.

### `:Bmessagessp`

Creates a message buffer with a horizontal split, overriding the `split_type` to `split`.

### `:BmessagesEdit`

Creates a editable message buffer with the configured options without auto updating.

### Lua API

```lua
require("bmessages").toggle({ split_type = "split" })
```

## ⌨️  Keymaps

No keymaps are set by default, but you can easily set your own keymaps to open the messages buffer.

```lua
vim.api.nvim_set_keymap("n", "<leader>bm", ":Bmessages<CR>", { noremap = true, silent = true })
```


## 👏 Acknowledgements

* [plugin-template.nvim](https://github.com/m00qek/plugin-template.nvim)
