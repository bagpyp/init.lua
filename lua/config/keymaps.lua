-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- JetBrains-style Panel System: Space+1-8 (works in all terminals!)
map("n", "<leader>1", "<cmd>Neotree toggle<cr>", { desc = "📁 File Explorer" })
map("n", "<leader>2", "<cmd>Telescope git_status<cr>", { desc = "🔀 Git Status" })
map("n", "<leader>3", "<cmd>lua require('config.run').toggle()<cr>", { desc = "▶️ Run Configs" })
map("n", "<leader>4", "<cmd>lua require('dapui').toggle()<cr>", { desc = "🐛 Debugger" })
map("n", "<leader>5", "<cmd>DBUI<cr>", { desc = "💾 Database" })
map("n", "<leader>6", "<cmd>lua require('config.docker').toggle()<cr>", { desc = "🐳 Services (Docker)" })
map("n", "<leader>7", "<cmd>SymbolsOutline<cr>", { desc = "🏗️ Structure" })
map("n", "<leader>8", "<cmd>ToggleTerm<cr>", { desc = "💻 Terminal" })

-- Test mappings
map("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run Nearest Test" })
map("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run File Tests" })
map("n", "<leader>to", "<cmd>lua require('neotest').output.open()<cr>", { desc = "Test Output" })
map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Toggle Test Summary" })

-- Run config cycling
map("n", "<leader>rn", "<cmd>lua require('config.run').next()<cr>", { desc = "Next Run Config" })
map("n", "<leader>rp", "<cmd>lua require('config.run').prev()<cr>", { desc = "Previous Run Config" })

-- Debugging F-keys
map("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", { desc = "Debug Continue" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", { desc = "Debug Step Over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", { desc = "Debug Step Into" })
map("n", "<S-F11>", "<cmd>lua require('dap').step_out()<cr>", { desc = "Debug Step Out" })
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dr", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle Debug UI" })

-- Refactoring mappings (JetBrains style)
map("n", "<S-F6>", vim.lsp.buf.rename, { desc = "🏷️ Rename Symbol" })
map("n", "<F6>", "<cmd>Move<cr>", { desc = "📦 Move File" })
map("v", "M", "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", { desc = "🎯 Extract Method" })
map("n", "<leader>ri", "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", { desc = "🔗 Inline Variable" })

-- Multi-cursor and selection
map("n", "<C-g>", "<cmd>lua require('vim-visual-multi').start()<cr>", { desc = "🎯 Add Cursor" })
map("v", "<C-Up>", "<Plug>(expand_region_expand)", { desc = "🔼 Expand Selection" })
map("v", "<C-Down>", "<Plug>(expand_region_shrink)", { desc = "🔽 Shrink Selection" })
map("n", "<S-Up>", "<cmd>move -2<cr>==", { desc = "⬆️ Move Line Up" })
map("n", "<S-Down>", "<cmd>move +1<cr>==", { desc = "⬇️ Move Line Down" })
map("v", "<S-Up>", ":move '<-2<cr>gv=gv", { desc = "⬆️ Move Selection Up" })
map("v", "<S-Down>", ":move '>+1<cr>gv=gv", { desc = "⬇️ Move Selection Down" })

-- Recent files and tab management
map("n", "<S-Tab>", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
map("n", "<leader>tc", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- Additional useful mappings (JetBrains style)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "🔍 Find Files" })
map("n", "<leader>fp", "<cmd>Telescope commands<cr>", { desc = "🎛️ Command Palette" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "🔎 Search in Files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "📋 Switch Buffer" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

