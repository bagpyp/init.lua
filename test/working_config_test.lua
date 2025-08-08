-- Comprehensive working configuration test
local helpers = require("test.helpers")

print("🧪 Testing Your JetBrains-Style Neovim Configuration")
print("====================================================")

local success_count = 0
local total_count = 0

local function test(name, func)
  total_count = total_count + 1
  local success, err = pcall(func)
  if success then
    print("✅ " .. name)
    success_count = success_count + 1
  else
    print("❌ " .. name .. " - " .. (err or "unknown error"))
  end
end

-- Test 1: Basic Configuration Loading
test("Configuration loads without errors", function()
  assert(vim ~= nil, "Vim is not available")
  assert(vim.g.mapleader == " ", "Leader key should be space")
end)

-- Test 2: Space+1-8 Panel Keybindings  
test("Space+1-8 panel shortcuts are configured", function()
  local function has_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        return true
      end
    end
    return false
  end
  
  local panels = {"1", "2", "3", "4", "5", "6", "7", "8"}
  for _, num in ipairs(panels) do
    local key = "<leader>" .. num
    assert(has_keymap("n", key), "Missing Space+" .. num .. " mapping")
  end
end)

-- Test 3: Core Options
test("Core Neovim options are set correctly", function()
  assert(vim.opt.number:get() == true, "Line numbers should be enabled")
  assert(vim.opt.relativenumber:get() == true, "Relative numbers should be enabled")
  assert(vim.opt.signcolumn:get() == "yes", "Sign column should be enabled")
  assert(vim.opt.wrap:get() == false, "Line wrap should be disabled")
end)

-- Test 4: Plugin Directories Exist
test("Plugin configuration files exist", function()
  local plugin_files = {
    "lua/plugins/jetbrains.lua",
    "lua/plugins/lsp.lua", 
    "lua/plugins/treesitter.lua",
    "lua/plugins/telescope.lua"
  }
  
  for _, file in ipairs(plugin_files) do
    local full_path = vim.fn.stdpath("config") .. "/" .. file
    assert(vim.fn.filereadable(full_path) == 1, "Plugin file missing: " .. file)
  end
end)

-- Test 5: Refactoring Shortcuts
test("Refactoring shortcuts are configured", function()
  local function has_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        return true
      end
    end
    return false
  end
  
  -- Check for Shift+F6 rename
  assert(has_keymap("n", "<S-F6>"), "Shift+F6 rename should be mapped")
  -- Check for F6 move
  assert(has_keymap("n", "<F6>"), "F6 move should be mapped")
end)

-- Test 6: Debug F-Keys
test("Debug F-key shortcuts are configured", function()
  local function has_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        return true
      end
    end
    return false
  end
  
  assert(has_keymap("n", "<F5>"), "F5 debug continue should be mapped")
  assert(has_keymap("n", "<F10>"), "F10 debug step over should be mapped") 
  assert(has_keymap("n", "<F11>"), "F11 debug step into should be mapped")
end)

-- Test 7: Find Shortcuts
test("Find shortcuts are configured (Space+f*)", function()
  local function has_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        return true
      end
    end
    return false
  end
  
  assert(has_keymap("n", "<leader>ff"), "Space+ff find files should be mapped")
  assert(has_keymap("n", "<leader>fg"), "Space+fg search in files should be mapped")
  assert(has_keymap("n", "<leader>fb"), "Space+fb switch buffer should be mapped")
end)

-- Test 8: Performance Settings
test("Performance optimizations are active", function()
  -- Check that some heavy built-in plugins are disabled
  assert(vim.g.loaded_gzip == 1, "gzip plugin should be disabled")
  assert(vim.g.loaded_tarPlugin == 1, "tar plugin should be disabled") 
  assert(vim.g.loaded_zipPlugin == 1, "zip plugin should be disabled")
end)

-- Test 9: Custom Modules
test("Custom run and docker modules load", function()
  local run_ok = pcall(require, "config.run")
  assert(run_ok, "Run module should load")
  
  local docker_ok = pcall(require, "config.docker") 
  assert(docker_ok, "Docker module should load")
end)

-- Test 10: Window Management
test("Window navigation shortcuts work", function()
  local function has_keymap(mode, lhs)
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs == lhs then
        return true
      end
    end
    return false
  end
  
  assert(has_keymap("n", "<C-h>"), "Ctrl+h left window should be mapped")
  assert(has_keymap("n", "<C-j>"), "Ctrl+j down window should be mapped") 
  assert(has_keymap("n", "<C-k>"), "Ctrl+k up window should be mapped")
  assert(has_keymap("n", "<C-l>"), "Ctrl+l right window should be mapped")
end)

print("====================================================")
print(string.format("🎯 Results: %d/%d tests passed (%.1f%%)", 
  success_count, total_count, (success_count/total_count)*100))

if success_count == total_count then
  print("🎉 All tests passed! Your configuration is working perfectly!")
  print("✅ Your Space+1-8 JetBrains shortcuts are properly configured")
  print("✅ Debug F-keys are set up correctly")
  print("✅ Refactoring shortcuts are working")
  print("✅ Performance optimizations are active")
else
  print("⚠️  Some tests failed. Check the errors above.")
end

print("====================================================")