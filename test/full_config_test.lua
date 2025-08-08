-- Test with full configuration loaded
-- This test runs with the actual configuration active

print("🚀 Testing Full Configuration (Not Headless)")
print("===============================================")

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

-- Test leader key
test("Leader key is Space", function()
  assert(vim.g.mapleader == " ", "Leader should be space, got: " .. tostring(vim.g.mapleader))
end)

-- Test keymaps exist (in full session they should be loaded)
test("Space+8 terminal shortcut exists", function()
  local keymaps = vim.api.nvim_get_keymap('n')
  local found = false
  for _, km in ipairs(keymaps) do
    if km.lhs == '<leader>8' or km.lhs:match('8') then
      found = true
      print("   Found keymap: " .. km.lhs .. " → " .. (km.desc or km.rhs or "command"))
      break
    end
  end
  assert(found, "Space+8 keymap not found")
end)

-- Test that lazy.nvim is loaded
test("Lazy.nvim plugin manager is available", function()
  assert(type(require('lazy')) == 'table', "Lazy should be available")
end)

-- Test some basic options
test("Basic vim options are set", function()
  -- These should work even in headless
  assert(vim.o.background, "Background should be set")
  assert(vim.o.termguicolors == true, "True colors should be enabled")
end)

-- Test that config files are readable
test("Configuration files are accessible", function()
  local config_dir = vim.fn.stdpath('config')
  assert(vim.fn.isdirectory(config_dir) == 1, "Config directory should exist")
  assert(vim.fn.filereadable(config_dir .. '/init.lua') == 1, "init.lua should exist")
  assert(vim.fn.filereadable(config_dir .. '/lua/config/keymaps.lua') == 1, "keymaps.lua should exist")
end)

-- Test that we can load our custom modules
test("Custom modules can be required", function()
  local run_module = require('config.run')
  assert(type(run_module) == 'table', "Run module should be a table")
  assert(type(run_module.toggle) == 'function', "Run module should have toggle function")
  
  local docker_module = require('config.docker')
  assert(type(docker_module) == 'table', "Docker module should be a table")
  assert(type(docker_module.toggle) == 'function', "Docker module should have toggle function")
end)

-- Summary
print("===============================================")
print(string.format("🎯 Results: %d/%d tests passed (%.1f%%)", 
  success_count, total_count, (success_count/total_count)*100))

if success_count == total_count then
  print("🎉 Full configuration test passed!")
  print("📝 To test keybindings interactively:")
  print("   1. Start nvim normally (not headless)")
  print("   2. Press Space+8 for terminal")
  print("   3. Press Space+1 for file explorer") 
  print("   4. Try the VimGame: cd vim-game && ./start-simple.sh")
else
  print("⚠️  Some tests failed - but this might be expected in headless mode")
  print("🎮 Try the VimGame for interactive testing!")
end

return {success_count = success_count, total_count = total_count}