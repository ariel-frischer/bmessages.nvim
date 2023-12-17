local bmessages = require('bmessages')
local mock = require('luassert.mock')
local match = require('luassert.match')
local assert = require('luassert')

local function buffer_exists(buf_name)
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    print('bufnames', vim.api.nvim_buf_get_name(bufnr))
    if string.find(vim.api.nvim_buf_get_name(bufnr), buf_name) then
      return true
    end
  end
  return false
end

describe("bmessages plugin", function()
  before_each(function()
    bmessages.setup({})
  end)

  after_each(function()
    if buffer_exists("bmessages_buffer") then
      vim.api.nvim_buf_delete(vim.fn.bufnr("bmessages_buffer"), { force = true })
    end
  end)


  describe("setup function", function()
    it("should create user commands", function()
      local api = mock(vim.api, true)
      bmessages.setup({}) -- assuming default options
      assert.stub(api.nvim_create_user_command).was_called_with('Bmessages', match.is_function(), {})
      assert.stub(api.nvim_create_user_command).was_called_with('Bmessagesvs', match.is_function(), {})
      assert.stub(api.nvim_create_user_command).was_called_with('Bmessagessp', match.is_function(), {})
      mock.revert(api)
    end)
  end)

  describe("toggle function", function()
    it("should create a buffer and update current_split_type", function()
      assert.equals(bmessages.current_split_type, nil)
      local buf_count = #vim.api.nvim_list_bufs()
      bmessages.toggle({ split_type = "split" })
      local after_buf_count = #vim.api.nvim_list_bufs()

      assert.equals(1, buf_count)
      assert.equals(2, after_buf_count)
      assert.equals(bmessages.current_split_type, "split")
    end)
  end)

  it("should execute :Bmessages command correctly", function()
    local bufferExists = buffer_exists("bmessages_buffer")
    assert.is_false(bufferExists, "Buffer 'bmessages_buffer' should not exist")

    vim.cmd("Bmessages") -- Simulate running the :Bmessages command in Neovim

    bufferExists = buffer_exists("bmessages_buffer")

    assert.is_true(bufferExists, "Buffer 'bmessages_buffer' should exist")
  end)
end)
