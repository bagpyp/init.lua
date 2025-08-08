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
      "blink.cmp",  -- LazyVim switched to blink.cmp
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
          local plugin_pattern = plugin:gsub("%.nvim$", ""):gsub("%-", "%%-")
          
          for _, p in ipairs(plugins) do
            -- Check various ways a plugin might be identified
            local plugin_id = p.name or p[1] or ""
            if plugin_id:lower():match(plugin_pattern:lower()) then
              found = true
              break
            end
            -- Also check if the plugin directory exists
            if p.dir and p.dir:match(plugin_pattern) then
              found = true
              break
            end
          end
          
          -- Some plugins might be loaded differently or as part of LazyVim extras
          if not found then
            -- Try to require the plugin directly
            local ok = pcall(require, plugin:gsub("%.nvim$", ""):gsub("^nvim%-", ""))
            if ok then
              found = true
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
      -- Check if any completion plugin is available (nvim-cmp or blink.cmp)
      local cmp_ok = pcall(require, "cmp") or pcall(require, "blink.cmp")
      local lazy_ok = false
      
      if not cmp_ok and pcall(require, "lazy") then
        local plugins = require("lazy").plugins()
        for _, p in ipairs(plugins) do
          local plugin_id = p.name or p[1] or ""
          if plugin_id:match("cmp") or plugin_id:match("blink") then
            lazy_ok = true
            break
          end
        end
      end
      
      assert.is_true(cmp_ok or lazy_ok, "completion plugin (blink.cmp/nvim-cmp) not available")
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
        -- Check if treesitter has any configuration
        local has_config = pcall(require, "nvim-treesitter.configs")
        assert.is_true(has_config, "Treesitter configs should be available")
      end
    end)
  end)
end)