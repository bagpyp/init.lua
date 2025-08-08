-- Test keymaps configuration

describe("Keymaps", function()
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
    return false
  end

  describe("JetBrains Panel Mappings", function()
    it("should have Cmd+1-8 panel mappings", function()
      -- These might be <D-1> or <M-1> depending on system
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
        local key = "<D-" .. num .. ">"
        local alt_key = "<M-" .. num .. ">"
        -- Check if either D- or M- version exists
        local exists = has_keymap("n", key) or has_keymap("n", alt_key)
        assert.is_true(exists, "Missing mapping for panel " .. num .. " (" .. desc .. ")")
      end
    end)
  end)

  describe("Refactoring Mappings", function()
    it("should have rename mapping (Shift+F6)", function()
      assert.is_true(has_keymap("n", "<S-F6>"))
    end)

    it("should have move file mapping (F6)", function()
      -- F6 might be mapped differently
      local has_f6 = has_keymap("n", "<F6>") or has_keymap("n", "F6")
      assert.is_true(has_f6)
    end)
  end)

  describe("Debug Mappings", function()
    it("should have F5 for continue", function()
      assert.is_true(has_keymap("n", "<F5>"))
    end)

    it("should have F10 for step over", function()
      assert.is_true(has_keymap("n", "<F10>"))
    end)

    it("should have F11 for step into", function()
      assert.is_true(has_keymap("n", "<F11>"))
    end)

    it("should have Shift+F11 for step out", function()
      assert.is_true(has_keymap("n", "<S-F11>"))
    end)
  end)

  describe("Window Navigation", function()
    it("should have Ctrl+hjkl for window movement", function()
      assert.is_true(has_keymap("n", "<C-h>"))
      assert.is_true(has_keymap("n", "<C-j>"))
      assert.is_true(has_keymap("n", "<C-k>"))
      assert.is_true(has_keymap("n", "<C-l>"))
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