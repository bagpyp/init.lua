-- Run configuration management (similar to JetBrains Run Configs)
local M = {}

-- Store run configurations
M.configs = {
  {
    name = "npm start",
    cmd = "npm start",
    type = "terminal",
  },
  {
    name = "npm test",
    cmd = "npm test",
    type = "terminal",
  },
  {
    name = "npm run dev",
    cmd = "npm run dev",
    type = "terminal",
  },
  {
    name = "pytest",
    cmd = "pytest",
    type = "terminal",
  },
  {
    name = "python main.py",
    cmd = "python main.py",
    type = "terminal",
  },
}

M.current_index = 1
M.is_visible = false
M.buf = nil
M.win = nil

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

  -- Create buffer if it doesn't exist
  if not M.buf or not vim.api.nvim_buf_is_valid(M.buf) then
    M.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(M.buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(M.buf, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(M.buf, "swapfile", false)
  end

  -- Create window
  local width = 40
  local height = #M.configs + 4
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
    title = " Run Configurations ",
    title_pos = "center",
  })

  M.render()
  M.setup_keymaps()
  M.is_visible = true
end

function M.hide()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
  end
  M.is_visible = false
end

function M.render()
  local lines = {}
  for i, config in ipairs(M.configs) do
    local prefix = i == M.current_index and "▶ " or "  "
    table.insert(lines, prefix .. config.name)
  end
  
  table.insert(lines, "")
  table.insert(lines, "Press <Enter> to run")
  table.insert(lines, "Press q to close")
  
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
end

function M.setup_keymaps()
  local opts = { buffer = M.buf, silent = true }
  
  vim.keymap.set("n", "<CR>", function()
    M.run_current()
    M.hide()
  end, opts)
  
  vim.keymap.set("n", "q", function()
    M.hide()
  end, opts)
  
  vim.keymap.set("n", "j", function()
    M.next()
    M.render()
  end, opts)
  
  vim.keymap.set("n", "k", function()
    M.prev()
    M.render()
  end, opts)
end

function M.run_current()
  local config = M.configs[M.current_index]
  if not config then
    return
  end
  
  if config.type == "terminal" then
    vim.cmd("TermExec cmd='" .. config.cmd .. "'")
  elseif config.type == "dap" then
    require("neotest").run.run({ strategy = "dap" })
  end
end

function M.next()
  M.current_index = M.current_index % #M.configs + 1
  if M.is_visible then
    M.render()
  end
end

function M.prev()
  M.current_index = M.current_index == 1 and #M.configs or M.current_index - 1
  if M.is_visible then
    M.render()
  end
end

-- Load project-specific configs if available
function M.load_project_configs()
  local config_file = vim.fn.getcwd() .. "/.nvim-run-configs.json"
  if vim.fn.filereadable(config_file) == 1 then
    local file = io.open(config_file, "r")
    if file then
      local content = file:read("*all")
      file:close()
      local ok, configs = pcall(vim.json.decode, content)
      if ok and configs then
        M.configs = configs
      end
    end
  end
end

-- Save current configs to project
function M.save_project_configs()
  local config_file = vim.fn.getcwd() .. "/.nvim-run-configs.json"
  local file = io.open(config_file, "w")
  if file then
    file:write(vim.json.encode(M.configs))
    file:close()
  end
end

-- Initialize
M.load_project_configs()

return M