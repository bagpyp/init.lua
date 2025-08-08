-- Integration tests for workflows

describe("Integration Tests", function()
  describe("File Operations", function()
    it("should create and edit a file", function()
      local test_file = vim.fn.tempname() .. ".lua"
      vim.cmd("edit " .. test_file)
      
      -- Insert some text
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        "-- Test file",
        "local M = {}",
        "return M"
      })
      
      -- Save the file
      vim.cmd("write")
      
      -- Check file exists
      assert.is_true(vim.fn.filereadable(test_file) == 1)
      
      -- Clean up
      vim.fn.delete(test_file)
    end)
  end)

  describe("Window Management", function()
    it("should split windows", function()
      local initial_win = vim.api.nvim_get_current_win()
      
      -- Split horizontally
      vim.cmd("split")
      local split_win = vim.api.nvim_get_current_win()
      assert.are_not.equal(initial_win, split_win)
      
      -- Split vertically
      vim.cmd("vsplit")
      local vsplit_win = vim.api.nvim_get_current_win()
      assert.are_not.equal(split_win, vsplit_win)
      
      -- Check we have 3 windows
      local windows = vim.api.nvim_list_wins()
      assert.is_true(#windows >= 3)
      
      -- Clean up - close splits
      vim.cmd("only")
    end)

    it("should navigate between windows", function()
      vim.cmd("split")
      vim.cmd("vsplit")
      
      local start_win = vim.api.nvim_get_current_win()
      
      -- Navigate with C-hjkl
      vim.cmd("wincmd h")
      local left_win = vim.api.nvim_get_current_win()
      
      vim.cmd("wincmd l")
      local right_win = vim.api.nvim_get_current_win()
      
      -- Windows should be different
      assert.are_not.equal(left_win, right_win)
      
      -- Clean up
      vim.cmd("only")
    end)
  end)

  describe("Buffer Management", function()
    it("should handle multiple buffers", function()
      -- Get initial buffer count
      local initial_buffers = vim.api.nvim_list_bufs()
      local initial_count = #initial_buffers
      
      -- Create multiple new buffers
      local bufs = {}
      for i = 1, 3 do
        vim.cmd("enew")
        table.insert(bufs, vim.api.nvim_get_current_buf())
      end
      
      -- Check that we created new buffers
      local final_buffers = vim.api.nvim_list_bufs()
      local final_count = #final_buffers
      
      -- We should have created some buffers (may not be exactly 3 due to buffer reuse)
      assert.is_true(final_count > initial_count, 
        string.format("Expected more than %d buffers, got %d", initial_count, final_count))
      
      -- The buffers we created should be valid
      for _, buf in ipairs(bufs) do
        assert.is_true(vim.api.nvim_buf_is_valid(buf))
      end
    end)
  end)

  describe("Search and Replace", function()
    it("should perform search", function()
      -- Create buffer with content
      local lines = {
        "First line without match",
        "Hello world",
        "Hello neovim",
        "Hello testing"
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      
      -- Go to beginning of buffer
      vim.api.nvim_win_set_cursor(0, {1, 0})
      
      -- Search for "Hello" - should find first occurrence
      local found = vim.fn.search("Hello")
      assert.is_true(found > 0, "Pattern not found")
      local pos = vim.api.nvim_win_get_cursor(0)
      assert.are.equal(2, pos[1]) -- Second line (first with "Hello")
      
      -- Search next occurrence
      found = vim.fn.search("Hello", "W")
      assert.is_true(found > 0, "Next pattern not found")
      pos = vim.api.nvim_win_get_cursor(0)
      assert.are.equal(3, pos[1]) -- Third line (second with "Hello")
    end)

    it("should perform substitution", function()
      local lines = {
        "foo bar foo",
        "foo baz foo"
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      
      -- Replace foo with test
      vim.cmd("%s/foo/test/g")
      
      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.are.equal("test bar test", result[1])
      assert.are.equal("test baz test", result[2])
    end)
  end)

  describe("Fold Operations", function()
    it("should have fold settings configured", function()
      assert.are.equal("expr", vim.opt.foldmethod:get())
      assert.are.equal(false, vim.opt.foldenable:get())
    end)
  end)

  describe("Clipboard Operations", function()
    it("should use system clipboard", function()
      -- This is deferred in performance settings
      vim.wait(500, function()
        local clip = vim.opt.clipboard:get()
        return vim.tbl_contains(clip, "unnamedplus")
      end)
      
      local clip = vim.opt.clipboard:get()
      assert.is_true(vim.tbl_contains(clip, "unnamedplus"))
    end)
  end)
end)