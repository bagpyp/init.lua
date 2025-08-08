-- Performance benchmark tests

local helpers = require("tests.helpers")

describe("Performance", function()
  describe("Startup Time", function()
    it("should start quickly", function()
      -- This test is more symbolic since we're already running
      -- Real startup time should be measured externally
      assert.is_true(vim.fn.has("nvim-0.9") == 1, "Should be running recent Neovim")
    end)

    it("should have lazy loading configured", function()
      local lazy_ok, lazy = pcall(require, "lazy")
      if lazy_ok then
        local stats = lazy.stats()
        -- Check that not all plugins are loaded immediately
        assert.is_true(stats.count > stats.loaded, 
          "All plugins loaded immediately - lazy loading not working")
      end
    end)
  end)

  describe("Large File Handling", function()
    it("should detect large files", function()
      -- Create a large content string (>1MB)
      local large_content = string.rep("a", 1024 * 1024 + 1)
      
      helpers.with_temp_file(large_content, function(temp_file)
        vim.cmd("edit " .. temp_file)
        
        -- Check if large file optimizations are applied
        local buf = vim.api.nvim_get_current_buf()
        
        -- After BufReadPre autocmd, these should be set
        vim.wait(100) -- Wait for autocmd
        
        assert.is_true(vim.b[buf].large_file == true, "Large file not detected")
      end)
    end)
  end)

  describe("Memory Usage", function()
    it("should not leak memory on buffer operations", function()
      local initial_mem = collectgarbage("count")
      
      -- Create and delete multiple buffers
      for i = 1, 100 do
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
          "Line 1", "Line 2", "Line 3"
        })
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      
      collectgarbage("collect")
      local final_mem = collectgarbage("count")
      
      -- Memory shouldn't increase significantly (allow 10% increase)
      local mem_increase = (final_mem - initial_mem) / initial_mem
      assert.is_true(mem_increase < 0.1, 
        string.format("Memory increased by %.2f%%", mem_increase * 100))
    end)
  end)

  describe("Plugin Loading", function()
    it("should load plugins on demand", function()
      local lazy_ok, lazy = pcall(require, "lazy")
      if not lazy_ok then
        pending("Lazy.nvim not available")
        return
      end
      
      local plugins = lazy.plugins()
      local lazy_count = 0
      local immediate_count = 0
      
      for _, plugin in ipairs(plugins) do
        if plugin.lazy ~= false then
          if plugin.cmd or plugin.keys or plugin.ft or plugin.event then
            lazy_count = lazy_count + 1
          end
        else
          immediate_count = immediate_count + 1
        end
      end
      
      -- Most plugins should be lazy loaded
      assert.is_true(lazy_count > immediate_count,
        string.format("Only %d lazy vs %d immediate plugins", lazy_count, immediate_count))
    end)
  end)

  describe("Benchmark Operations", function()
    it("should handle search operations efficiently", function()
      -- Create buffer with many lines
      local lines = {}
      for i = 1, 10000 do
        table.insert(lines, string.format("Line %d with some text", i))
      end
      
      local buf = helpers.create_test_buffer(lines)
      vim.api.nvim_set_current_buf(buf)
      
      -- Benchmark search operation
      local search_time = helpers.benchmark(function()
        vim.fn.search("Line 5000")
      end, 10)
      
      -- Should complete in reasonable time (< 10ms average)
      assert.is_true(search_time < 10,
        string.format("Search took %.2fms (threshold: 10ms)", search_time))
    end)

    it("should handle substitution efficiently", function()
      local lines = {}
      for i = 1, 1000 do
        table.insert(lines, "foo bar baz foo bar")
      end
      
      local buf = helpers.create_test_buffer(lines)
      vim.api.nvim_set_current_buf(buf)
      
      -- Benchmark substitution
      local sub_time = helpers.benchmark(function()
        vim.cmd("silent! %s/foo/test/g")
        -- Undo to repeat test
        vim.cmd("silent! undo")
      end, 5)
      
      -- Should complete in reasonable time (< 50ms average)
      assert.is_true(sub_time < 50,
        string.format("Substitution took %.2fms (threshold: 50ms)", sub_time))
    end)
  end)
end)