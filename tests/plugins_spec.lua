-- Test plugin configurations

describe("Plugins", function()
  local lazy_ok, lazy = pcall(require, "lazy")
  
  describe("Plugin Manager", function()
    it("should have lazy.nvim installed", function()
      assert.is_true(lazy_ok, "lazy.nvim is not installed")
    end)

    it("should load plugins without errors", function()
      if lazy_ok then
        local stats = lazy.stats()
        assert.is_not_nil(stats)
        assert.is_true(stats.loaded > 0, "No plugins loaded")
      end
    end)
  end)

  describe("Essential Plugins", function()
    local essential_plugins = {
      "neo-tree.nvim",
      "telescope.nvim",
      "nvim-treesitter",
      "nvim-lspconfig",
      "nvim-cmp",
      "gitsigns.nvim",
      "which-key.nvim",
      "toggleterm.nvim",
      "nvim-dap",
      "neotest",
    }

    for _, plugin in ipairs(essential_plugins) do
      it("should have " .. plugin .. " configured", function()
        if lazy_ok then
          local plugins = require("lazy").plugins()
          local found = false
          for _, p in ipairs(plugins) do
            if p.name and p.name:match(plugin:gsub("%.nvim$", "")) then
              found = true
              break
            end
          end
          assert.is_true(found, plugin .. " not found in configuration")
        end
      end)
    end
  end)

  describe("Lazy Loading", function()
    it("should have lazy loading configured for heavy plugins", function()
      if lazy_ok then
        local plugins = require("lazy").plugins()
        local lazy_loaded = {}
        
        for _, plugin in ipairs(plugins) do
          if plugin.lazy ~= false then
            -- Check if plugin has lazy loading triggers
            if plugin.cmd or plugin.keys or plugin.ft or plugin.event then
              table.insert(lazy_loaded, plugin.name or plugin[1])
            end
          end
        end
        
        assert.is_true(#lazy_loaded > 10, "Not enough plugins are lazy loaded")
      end
    end)
  end)

  describe("LSP", function()
    it("should have LSP configured", function()
      local lsp_ok = pcall(require, "lspconfig")
      assert.is_true(lsp_ok, "lspconfig not available")
    end)

    it("should have completion configured", function()
      local cmp_ok = pcall(require, "cmp")
      assert.is_true(cmp_ok, "nvim-cmp not available")
    end)
  end)

  describe("Treesitter", function()
    it("should have treesitter configured", function()
      local ts_ok = pcall(require, "nvim-treesitter")
      assert.is_true(ts_ok, "treesitter not available")
    end)

    it("should have parsers configured", function()
      local ts_ok, _ = pcall(require, "nvim-treesitter.configs")
      if ts_ok then
        local configs = require("nvim-treesitter.configs").get_module("ensure_installed")
        assert.is_not_nil(configs)
      end
    end)
  end)
end)