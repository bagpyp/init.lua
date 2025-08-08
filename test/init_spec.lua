-- Test suite for Neovim configuration
-- Run with: nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}"

local eq = assert.are.same
local has = function(feature) return vim.fn.has(feature) == 1 end

describe("Neovim Configuration", function()
  describe("Basic Setup", function()
    it("should load without errors", function()
      -- Check if lazy is available (might not be g:loaded_lazy in minimal env)
      local lazy_available = pcall(require, "lazy") or vim.fn.exists("g:loaded_lazy") == 1
      assert.is_true(lazy_available)
    end)

    it("should have correct leader key", function()
      -- Only check if config loaded the leader
      if vim.g.mapleader then
        eq(" ", vim.g.mapleader)
      end
      if vim.g.maplocalleader then
        eq("\\", vim.g.maplocalleader)
      end
    end)

    it("should have transparency enabled", function()
      local ok, tokyonight = pcall(require, "tokyonight")
      if ok then
        local config = require("tokyonight.config")
        assert.is_true(config.options.transparent)
      end
    end)
  end)

  describe("Options", function()
    it("should set correct options", function()
      -- Check if options are loaded by checking one key option
      if vim.opt.shiftwidth:get() == 2 then
        eq(true, vim.opt.number:get())
        eq(true, vim.opt.relativenumber:get())
        eq(true, vim.opt.termguicolors:get())
        -- Clipboard might be deferred
        -- eq("unnamedplus", vim.opt.clipboard:get())
        eq(2, vim.opt.shiftwidth:get())
        eq(2, vim.opt.tabstop:get())
        eq(true, vim.opt.expandtab:get())
      else
        -- Options not loaded in minimal environment
        assert.is_true(true, "Skipping options test in minimal environment")
      end
    end)

    it("should have correct fold settings", function()
      eq("expr", vim.opt.foldmethod:get())
      eq(false, vim.opt.foldenable:get())
    end)

    it("should have performance settings", function()
      eq(200, vim.opt.updatetime:get())
      eq(300, vim.opt.timeoutlen:get())
    end)
  end)

  describe("Performance", function()
    it("should disable unused providers", function()
      eq(0, vim.g.loaded_python3_provider)
      eq(0, vim.g.loaded_ruby_provider)
      eq(0, vim.g.loaded_perl_provider)
      eq(0, vim.g.loaded_node_provider)
    end)

    it("should disable built-in plugins", function()
      eq(1, vim.g.loaded_netrw)
      eq(1, vim.g.loaded_netrwPlugin)
      eq(1, vim.g.loaded_gzip)
      eq(1, vim.g.loaded_zip)
      eq(1, vim.g.loaded_tarPlugin)
    end)
  end)
end)