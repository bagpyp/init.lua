-- Test helper functions

local M = {}

-- Helper to check if a plugin is loaded
function M.plugin_loaded(name)
  local ok, _ = pcall(require, name)
  return ok
end

-- Helper to check if a command exists
function M.command_exists(cmd)
  return vim.fn.exists(":" .. cmd) == 2
end

-- Helper to check if a keymap exists
function M.keymap_exists(mode, lhs)
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, keymap in ipairs(keymaps) do
    if keymap.lhs == lhs then
      return true
    end
  end
  return false
end

-- Helper to create a test buffer
function M.create_test_buffer(content)
  local buf = vim.api.nvim_create_buf(false, true)
  if content then
    if type(content) == "string" then
      content = vim.split(content, "\n")
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  end
  return buf
end

-- Helper to get buffer content
function M.get_buffer_content(buf)
  buf = buf or 0
  return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

-- Helper to simulate key press
function M.feed_keys(keys, mode)
  mode = mode or "n"
  local escaped = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(escaped, mode, false)
end

-- Helper to wait for condition
function M.wait_for(condition, timeout)
  timeout = timeout or 1000
  return vim.wait(timeout, condition)
end

-- Helper to check if LSP is attached
function M.lsp_attached(buf)
  buf = buf or 0
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  return #clients > 0
end

-- Helper to get diagnostics
function M.get_diagnostics(buf)
  buf = buf or 0
  return vim.diagnostic.get(buf)
end

-- Mock function for testing
function M.mock_function(returns)
  local calls = {}
  local fn = function(...)
    table.insert(calls, { ... })
    if type(returns) == "function" then
      return returns(...)
    else
      return returns
    end
  end
  fn.calls = calls
  fn.call_count = function()
    return #calls
  end
  fn.called_with = function(index)
    return calls[index] or {}
  end
  fn.reset = function()
    calls = {}
    fn.calls = calls
  end
  return fn
end

-- Helper to test async functions
function M.async_test(fn, timeout)
  timeout = timeout or 5000
  local done = false
  local result = nil
  local error_msg = nil
  
  local co = coroutine.create(function()
    local ok, res = pcall(fn)
    if ok then
      result = res
    else
      error_msg = res
    end
    done = true
  end)
  
  coroutine.resume(co)
  
  vim.wait(timeout, function()
    return done
  end)
  
  if error_msg then
    error(error_msg)
  end
  
  return result
end

-- Helper to benchmark function
function M.benchmark(fn, iterations)
  iterations = iterations or 100
  local start = vim.loop.hrtime()
  
  for _ = 1, iterations do
    fn()
  end
  
  local elapsed = vim.loop.hrtime() - start
  return elapsed / 1e6 / iterations -- Return average time in milliseconds
end

-- Helper to test with temporary file
function M.with_temp_file(content, fn)
  local temp_file = vim.fn.tempname()
  
  if content then
    local file = io.open(temp_file, "w")
    file:write(content)
    file:close()
  end
  
  local ok, result = pcall(fn, temp_file)
  
  -- Clean up
  vim.fn.delete(temp_file)
  
  if not ok then
    error(result)
  end
  
  return result
end

-- Helper to test with temporary directory
function M.with_temp_dir(fn)
  local temp_dir = vim.fn.tempname()
  vim.fn.mkdir(temp_dir, "p")
  
  local ok, result = pcall(fn, temp_dir)
  
  -- Clean up
  vim.fn.delete(temp_dir, "rf")
  
  if not ok then
    error(result)
  end
  
  return result
end

return M