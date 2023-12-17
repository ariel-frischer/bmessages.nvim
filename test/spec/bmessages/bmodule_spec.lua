local bmessages = require('bmessages')
local mock = require('luassert.mock')
local match = require('luassert.match')

describe("bmessages plugin", function()
  describe("setup function", function()
    it("should create user commands", function()
      mock(vim.api, true)

      bmessages.setup({}) -- assuming default options

      -- Check if user commands are created
      assert.stub(vim.api.nvim_create_user_command).was_called_with('Bmessages', match.is_function(), {})
      assert.stub(vim.api.nvim_create_user_command).was_called_with('Bmessagesvs', match.is_function(), {})
      assert.stub(vim.api.nvim_create_user_command).was_called_with('Bmessagessp', match.is_function(), {})

      mock.revert(vim.api)
    end)
  end)

  -- Additional tests for other aspects of the setup function or public interface
end)
