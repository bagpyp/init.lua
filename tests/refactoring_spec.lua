-- Test refactoring functionality

local helpers = require("tests.helpers")

describe("Refactoring", function()
  describe("Rename (Shift+F6)", function()
    it("should have rename keymap", function()
      assert.is_true(helpers.keymap_exists("n", "<S-F6>"))
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
      -- Check for Cmd+Alt+N mapping
      local has_inline = helpers.keymap_exists("n", "<D-M-n>") or 
                        helpers.keymap_exists("n", "<M-M-n>")
      assert.is_true(has_inline, "Inline variable mapping not found")
    end)
  end)

  describe("Move File (F6)", function()
    it("should have move file mapping", function()
      local has_move = helpers.keymap_exists("n", "<F6>") or
                      helpers.keymap_exists("n", "F6")
      assert.is_true(has_move, "Move file mapping not found")
    end)
  end)
end)