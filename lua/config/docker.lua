-- Docker services panel (similar to JetBrains Services tab)
local M = {}

M.is_visible = false
M.buf = nil
M.win = nil
M.containers = {}

function M.toggle()
  if M.is_visible then
    M.hide()
  else
    M.show()
  end
end

function M.show()
  if M.is_visible then
    return
  end

  -- Create buffer
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    M.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(M.buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(M.buf, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(M.buf, "swapfile", false)
  end

  -- Create window on the right side
  local width = 50
  local height = vim.o.lines - 6
  local col = vim.o.columns - width - 2
  local row = 2

  M.win = vim.api.nvim_open_win(M.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Docker Services ",
    title_pos = "center",
  })

  M.refresh()
  M.setup_keymaps()
  M.is_visible = true
end

function M.hide()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.is_visible = false
end

function M.refresh()
  -- Get docker containers
  local handle = io.popen("docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'")
  if handle then
    local result = handle:read("*a")
    handle:close()
    
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    
    vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
  end
  
  -- Add help text at the bottom
  local current_lines = vim.api.nvim_buf_get_lines(M.buf, 0, -1, false)
  table.insert(current_lines, "")
  table.insert(current_lines, "Commands:")
  table.insert(current_lines, "  r - Refresh")
  table.insert(current_lines, "  s - Start/Stop container")
  table.insert(current_lines, "  l - View logs")
  table.insert(current_lines, "  q - Close")
  
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, current_lines)
end

function M.setup_keymaps()
  local opts = { buffer = M.buf, silent = true }
  
  vim.keymap.set("n", "q", function()
    M.hide()
  end, opts)
  
  vim.keymap.set("n", "r", function()
    M.refresh()
  end, opts)
  
  vim.keymap.set("n", "s", function()
    local line = vim.api.nvim_get_current_line()
    local container = line:match("^(%S+)")
    if container and container ~= "NAMES" then
      vim.cmd("!docker stop " .. container .. " || docker start " .. container)
      M.refresh()
    end
  end, opts)
  
  vim.keymap.set("n", "l", function()
    local line = vim.api.nvim_get_current_line()
    local container = line:match("^(%S+)")
    if container and container ~= "NAMES" then
      vim.cmd("terminal docker logs -f " .. container)
    end
  end, opts)
end

return M