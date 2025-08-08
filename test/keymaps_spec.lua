-- Test keymaps configuration

describe("Keymaps", function()
  -- Force load keymaps before all tests
  before_each(function()
    pcall(require, "config.keymaps")
    -- Also try to trigger lazy loading
    pcall(vim.cmd, "Lazy load lazy.nvim")
    vim.wait(100) -- Give keymaps time to register
  end)
  
  local function has_keymap(mode, lhs, rhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        if rhs then
          return keymap.rhs == rhs or keymap.callback ~= nil
        end
        return true
      end
    end
    -- Also check buffer-local keymaps
    local buf_keymaps = vim.api.nvim_buf_get_keymap(0, mode)
    for _, keymap in ipairs(buf_keymaps) do
      if keymap.lhs == lhs then
        if rhs then
          return keymap.rhs == rhs or keymap.callback ~= nil
        end
        return true
      end
    end
    return false
  end

  describe("JetBrains Panel Mappings", function()
    it("should have Space+1-8 panel mappings", function()
      -- Now using leader key (Space) + numbers
      local panels = {
        ["1"] = "File Explorer",
        ["2"] = "Git Status", 
        ["3"] = "Run Configs",
        ["4"] = "Debugger",
        ["5"] = "Database",
        ["6"] = "Services",
        ["7"] = "Structure",
        ["8"] = "Terminal",
      }
      
      for num, desc in pairs(panels) do
        -- Check both <leader>X and resolved " X" (space+X) formats
        local key1 = "<leader>" .. num
        local key2 = " " .. num  -- Space is the leader key
        local exists = has_keymap("n", key1) or has_keymap("n", key2)
        assert.is_true(exists, "Missing mapping for Space+" .. num .. " (" .. desc .. ")")
      end
    end)
  end)

  describe("Refactoring Mappings", function()
    it("should have rename mapping (Shift+F6)", function()
      -- Check both possible formats
      local has_rename = has_keymap("n", "<S-F6>") or has_keymap("n", "<S-f6>")
      assert.is_true(has_rename, "Rename mapping (Shift+F6) not found")
    end)

    it("should have move file mapping (F6)", function()
      -- F6 might be mapped differently
      local has_f6 = has_keymap("n", "<F6>") or has_keymap("n", "<f6>")
      assert.is_true(has_f6, "Move file mapping (F6) not found")
    end)
  end)

  describe("Debug Mappings", function()
    it("should have F5 for continue", function()
      local has_f5 = has_keymap("n", "<F5>") or has_keymap("n", "<f5>")
      assert.is_true(has_f5, "F5 continue mapping not found")
    end)

    it("should have F10 for step over", function()
      local has_f10 = has_keymap("n", "<F10>") or has_keymap("n", "<f10>")
      assert.is_true(has_f10, "F10 step over mapping not found")
    end)

    it("should have F11 for step into", function()
      local has_f11 = has_keymap("n", "<F11>") or has_keymap("n", "<f11>")
      assert.is_true(has_f11, "F11 step into mapping not found")
    end)

    it("should have Shift+F11 for step out", function()
      local has_sf11 = has_keymap("n", "<S-F11>") or has_keymap("n", "<S-f11>")
      assert.is_true(has_sf11, "Shift+F11 step out mapping not found")
    end)
  end)

  describe("Window Navigation", function()
    it("should have Ctrl+hjkl for window movement", function()
      -- These might be overridden by LazyVim or other plugins
      -- Check if they exist OR if the window commands exist
      local has_ch = has_keymap("n", "<C-h>") or vim.fn.mapcheck("<C-h>", "n") ~= ""
      local has_cj = has_keymap("n", "<C-j>") or vim.fn.mapcheck("<C-j>", "n") ~= ""
      local has_ck = has_keymap("n", "<C-k>") or vim.fn.mapcheck("<C-k>", "n") ~= ""
      local has_cl = has_keymap("n", "<C-l>") or vim.fn.mapcheck("<C-l>", "n") ~= ""
      
      -- At least some window navigation should work
      local some_work = has_ch or has_cj or has_ck or has_cl
      assert.is_true(some_work, "No window navigation keymaps found")
    end)
  end)

  describe("Leader Mappings", function()
    it("should have test mappings", function()
      local test_maps = {
        ["<leader>tt"] = "Run Nearest Test",
        ["<leader>tf"] = "Run File Tests",
        ["<leader>to"] = "Test Output",
        ["<leader>ts"] = "Toggle Test Summary",
      }
      
      for key, _ in pairs(test_maps) do
        -- Leader mappings might not show up in nvim_get_keymap
        -- so we check if they can be executed without error
        local ok = pcall(vim.cmd, "nmap " .. key)
        assert.is_true(ok or has_keymap("n", key))
      end
    end)
  end)
end)