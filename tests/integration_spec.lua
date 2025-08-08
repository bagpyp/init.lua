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
      -- Create multiple buffers
      vim.cmd("enew")
      local buf1 = vim.api.nvim_get_current_buf()
      
      vim.cmd("enew")
      local buf2 = vim.api.nvim_get_current_buf()
      
      vim.cmd("enew")
      local buf3 = vim.api.nvim_get_current_buf()
      
      -- All buffers should be different
      assert.are_not.equal(buf1, buf2)
      assert.are_not.equal(buf2, buf3)
      assert.are_not.equal(buf1, buf3)
      
      -- Check buffer list
      local buffers = vim.api.nvim_list_bufs()
      assert.is_true(#buffers >= 3)
    end)
  end)

  describe("Search and Replace", function()
    it("should perform search", function()
      -- Create buffer with content
      local lines = {
        "Hello world",
        "Hello neovim",
        "Hello testing"
      }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      
      -- Search for "Hello"
      vim.fn.search("Hello")
      local pos = vim.api.nvim_win_get_cursor(0)
      assert.are.equal(1, pos[1]) -- First line
      
      -- Search next
      vim.fn.search("Hello")
      pos = vim.api.nvim_win_get_cursor(0)
      assert.are.equal(2, pos[1]) -- Second line
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
      vim.wait(200, function()
        return vim.opt.clipboard:get() == "unnamedplus"
      end)
      
      assert.are.equal("unnamedplus", vim.opt.clipboard:get())
    end)
  end)
end)