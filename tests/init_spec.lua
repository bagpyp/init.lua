-- Test suite for Neovim configuration
-- Run with: nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}"

local eq = assert.are.same
local has = function(feature) return vim.fn.has(feature) == 1 end

describe("Neovim Configuration", function()
  describe("Basic Setup", function()
    it("should load without errors", function()
      assert.is_true(vim.fn.exists("g:loaded_lazy") == 1)
    end)

    it("should have correct leader key", function()
      eq(" ", vim.g.mapleader)
      eq("\\", vim.g.maplocalleader)
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
      eq(true, vim.opt.number:get())
      eq(true, vim.opt.relativenumber:get())
      eq(true, vim.opt.termguicolors:get())
      eq("unnamedplus", vim.opt.clipboard:get())
      eq(2, vim.opt.shiftwidth:get())
      eq(2, vim.opt.tabstop:get())
      eq(true, vim.opt.expandtab:get())
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