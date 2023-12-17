-- Author: Ariel Frischer
-- email: arielfrischer@gmail.com

local M = {}

local function with_defaults(options)
  options = options or {}

  return {
    timer_interval = {
      description = "Time in milliseconds between each update of the messages buffer.",
      default = options.timer_interval or 1000
    },
    split_type = {
      description = "Default split type for the messages buffer (vsplit or split).",
      default = options.split_type or "vsplit"
    },
    buffer_name = {
      description = "Name of the messages buffer.",
      default = options.buffer_name or "messages_buffer"
    },
    split_size_vsplit = {
      description = "Size of the vertical split when opening the messages buffer. Check :h resize",
      default = options.split_size_vsplit or nil
    },
    split_size_split = {
      description = "Size of the horizontal split when opening the messages buffer. Check :h resize",
      default = options.split_size_split or nil
    },
    autoscroll = {
      description = "Automatically scroll to the latest message in the buffer.",
      default = options.autoscroll ~= nil and options.autoscroll or true
    },
    use_timer = {
      description =
      "Use a timer to auto-update the messages buffer. If this is false the buffer can be modified, but will not auto-update.",
      default = options.use_timer ~= nil and options.use_timer or true
    },
  }
end

local function update_messages_buffer()
  local new_messages = vim.api.nvim_exec("messages", true)
  if new_messages == "" then return nil end

  -- print('updated!')

  local bufnr = vim.fn.bufnr(M.options.buffer_name.default)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  local lines = vim.split(new_messages, "\n")

  local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  if not vim.deep_equal(current_lines, lines) then
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

    if M.options.autoscroll.default and vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) ~= M.options.buffer_name.default then
      local winnr = vim.fn.bufwinnr(bufnr)
      if winnr ~= -1 then
        local winid = vim.fn.win_getid(winnr)
        vim.api.nvim_win_set_cursor(winid, { #lines, 0 })
      end
    end
  end
end

local function create_messages_buffer(options)
  local cmd = options.split_type.default

  if cmd == "vsplit" and options.split_size_vsplit.default ~= nil then
    cmd = cmd .. " | vertical resize " .. options.split_size_vsplit.default
  elseif cmd == "split" and options.split_size_split.default ~= nil then
    cmd = cmd .. " | resize " .. options.split_size_split.default
  end

  vim.cmd(cmd .. " | enew")

  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(bufnr, options.buffer_name.default)
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(bufnr, 'bl', false)
  vim.api.nvim_buf_set_option(bufnr, 'swapfile', false)

  update_messages_buffer()
  if not options.use_timer.default then
    return nil
  end

  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  local timer = vim.loop.new_timer()
  timer:start(options.timer_interval.default, options.timer_interval.default, vim.schedule_wrap(update_messages_buffer))

  vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
    pattern = options.buffer_name.default,
    callback = function()
      if timer then
        timer:stop()
        timer:close()
        timer = nil
      end
    end,
  })
end

-- This function is supposed to be called explicitly by users to configure this plugin
function M.setup(options)
  M.options = with_defaults(options)

  vim.api.nvim_create_user_command('Bmessages', function()
    create_messages_buffer(M.options)
  end, {})

  vim.api.nvim_create_user_command('Bmessagesvs', function()
    create_messages_buffer(vim.tbl_deep_extend("force", {}, M.options, { split_type = { default = "vsplit" } }))
  end, {})

  vim.api.nvim_create_user_command('Bmessagessp', function()
    create_messages_buffer(vim.tbl_deep_extend("force", {}, M.options, { split_type = { default = "split" } }))
  end, {})
end

-- function M.is_configured()
--   return M.options ~= nil
-- end

M.options = nil
return M
