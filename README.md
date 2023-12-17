# 💬 Bmessages - Better Neovim Messages

`bmessages` is a Neovim plugin designed to significantly improve the developer experience by enhancing the default `:messages` functionality. It addresses the limitations of the default message window, which is static, non-interactive, and often cumbersome to use. With `:Bmessages`, you get an auto-updating, fully functional buffer that can be used like any other buffer in Neovim.

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
  cmd = {"Bmessages", "Bmessagesvs", "Bmessagessp"}
}
```

### ⚙️A Available Configuration Options

- `timer_interval`: Time in milliseconds between each update of the messages buffer (default: 1000).
- `split_type`: Default split type (`vsplit` or `split`) for the messages buffer (default: "vsplit").
- `buffer_name`: Name of the messages buffer (default: "messages_buffer").
- `split_size_vsplit`: Size of the vertical split (default: nil, uses Neovim's default behavior).
- `split_size_split`: Size of the horizontal split (default: nil, uses Neovim's default behavior).
- `autoscroll`: Automatically scroll to the latest message in the buffer (default: true).
- `use_timer`: Use a timer to auto-update the messages buffer (default: true).

## 🚀 Commands

- `:Bmessages`: Creates a message buffer with the configured options.
- `:Bmessagesvs`: Creates a message buffer with a vertical split, overriding the `split_type` to 'vsplit'.
- `:Bmessagessp`: Creates a message buffer with a horizontal split, overriding the `split_type` to 'split'.

