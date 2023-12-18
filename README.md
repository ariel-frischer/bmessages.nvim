[<img src="media/nvim.svg" height="60px" align="right" />](https://neovim.io/)

# 💬 Bmessages - Better Neovim Messages

![Preview](https://media.githubusercontent.com/media/ariel-frischer/bmessages.nvim/dev/media/preview.png)

## Test Preview


https://github.com/ariel-frischer/bmessages.nvim/assets/19893395/6ec66a27-865a-48c8-ab0c-b6bba10fdc3e



## ✨ Features

- **Auto-updating Buffers**: `bmessages` automatically updates the messages buffer, ensuring you always have the latest log messages at your fingertips.
- **Customizable Split Types**: Choose between horizontal (`split`) and vertical (`vsplit`) split types for displaying the messages buffer.
- **Resizable Splits**: Easily configure the size of the message buffer split, both for vertical and horizontal layouts.
- **Improved Usability**: The buffer behaves like any standard Neovim buffer, allowing for easier navigation and interaction.
- **Autoscroll Option**: Automatically scroll to the latest message, ensuring you're always viewing the most recent logs.

## 📦 Installation

Add `bmessages` to your Neovim configuration using your preferred package manager.

With lazy.nvim
```lua
{
  "ariel-frischer/bmessages.nvim",
  event = "CmdlineEnter",
  opts = {}
}
```

### ⚙️  Available Configuration Options

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

- `:Bmessages`: Creates a message buffer with the configured options.
- `:Bmessagesvs`: Creates a message buffer with a vertical split, overriding the `split_type` to `vsplit`.
- `:Bmessagessp`: Creates a message buffer with a horizontal split, overriding the `split_type` to `split`.

- Run the function directly:
```lua
require("bmessages").toggle({ split_type = "split" })
```

## ⌨️  Keymaps

```lua
vim.api.nvim_set_keymap("n", "<leader>bm", ":Bmessages<CR>", { noremap = true, silent = true })
```
