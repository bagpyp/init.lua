-- Optimized keymaps with lazy loading considerations
-- Only non-plugin keymaps here. Plugin keymaps are defined with the plugin for lazy loading.

local map = vim.keymap.set

-- Better window navigation (always available)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move lines up/down
map("n", "<S-D-Up>", "<cmd>move -2<cr>==", { desc = "Move Line Up" })
map("n", "<S-D-Down>", "<cmd>move +1<cr>==", { desc = "Move Line Down" })
map("v", "<S-D-Up>", ":move '<-2<cr>gv=gv", { desc = "Move Selection Up" })
map("v", "<S-D-Down>", ":move '>+1<cr>gv=gv", { desc = "Move Selection Down" })

-- Tab management
map("n", "<leader>tc", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Run config cycling (for custom run module)
map("n", "<S-D-]>", function() require("config.run").next() end, { desc = "Next Run Config" })
map("n", "<S-D-[>", function() require("config.run").prev() end, { desc = "Previous Run Config" })
map("n", "<D-3>", function() require("config.run").toggle() end, { desc = "Run Configs" })

-- Docker services
map("n", "<D-6>", function() require("config.docker").toggle() end, { desc = "Services (Docker)" })

-- Rename with Shift+F6 (LSP)
map("n", "<S-F6>", vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Inline variable
map("n", "<D-M-n>", function() 
  if pcall(require, "refactoring") then
    require("refactoring").refactor("Inline Variable")
  else
    vim.notify("Refactoring plugin not loaded", vim.log.levels.WARN)
  end
end, { desc = "Inline Variable" })

-- Better save
map({ "i", "v", "n", "s" }, "<D-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Clear search highlight
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Commenting (if Comment.nvim is not loaded)
map("n", "gcc", function()
  if pcall(require, "Comment.api") then
    require("Comment.api").toggle.linewise.current()
  else
    vim.cmd("normal! gcc")
  end
end, { desc = "Toggle comment" })

map("v", "gc", function()
  if pcall(require, "Comment.api") then
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
  else
    vim.cmd("normal! gc")
  end
end, { desc = "Toggle comment" })