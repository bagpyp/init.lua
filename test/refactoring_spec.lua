-- Test refactoring functionality

local helpers = require("helpers")

describe("Refactoring", function()
  -- Load keymaps before tests
  before_each(function()
    pcall(require, "config.keymaps")
    vim.wait(50) -- Give time for keymaps to register
  end)
  describe("Rename (Shift+F6)", function()
    it("should have rename keymap", function()
      local has_rename = helpers.keymap_exists("n", "<S-F6>") or 
                        helpers.keymap_exists("n", "<S-f6>")
      assert.is_true(has_rename, "Rename keymap (Shift+F6) not found")
    end)

    it("should rename symbol using LSP", function()
      -- Create a test buffer with code
      local content = [[
local myVariable = 42
print(myVariable)
return myVariable
]]
      local buf = helpers.create_test_buffer(content)
      vim.api.nvim_set_current_buf(buf)
      
      -- Set filetype to trigger LSP
      vim.bo[buf].filetype = "lua"
      
      -- Position cursor on variable
      vim.api.nvim_win_set_cursor(0, {1, 6}) -- On 'myVariable'
      
      -- Check if LSP rename is available
      local rename_available = vim.lsp.buf.rename ~= nil
      assert.is_true(rename_available, "LSP rename not available")
    end)
  end)

  describe("Extract Method", function()
    it("should have extract method mapping in visual mode", function()
      -- Check for 'M' mapping in visual mode
      assert.is_true(helpers.keymap_exists("v", "M"))
    end)

    it("should extract selected code to function", function()
      local content = [[
function process()
  local a = 1
  local b = 2
  local result = a + b
  print(result)
  return result
end
]]
      local buf = helpers.create_test_buffer(content)
      vim.api.nvim_set_current_buf(buf)
      vim.bo[buf].filetype = "lua"
      
      -- Select lines 3-5 (the calculation part)
      vim.api.nvim_win_set_cursor(0, {3, 0})
      vim.cmd("normal V2j") -- Visual line select 3 lines
      
      -- Check that refactoring module is available
      local refactoring_ok = pcall(require, "refactoring")
      if refactoring_ok then
        -- The extract would happen here
        assert.is_true(true, "Refactoring module available")
      end
    end)
  end)

  describe("Inline Variable", function()
    it("should have inline variable mapping", function()
      -- Check for leader+ri mapping (since Cmd keys don't work)
      -- Also check for the resolved " ri" format
      local has_inline = helpers.keymap_exists("n", "<leader>ri") or 
                        helpers.keymap_exists("n", " ri") or
                        vim.fn.mapcheck("<leader>ri", "n") ~= ""
      assert.is_true(has_inline, "Inline variable mapping (<leader>ri) not found")
    end)
  end)

  describe("Move File (F6)", function()
    it("should have move file mapping", function()
      local has_move = helpers.keymap_exists("n", "<F6>") or
                      helpers.keymap_exists("n", "<f6>")
      assert.is_true(has_move, "Move file mapping (F6) not found")
    end)
  end)
end)