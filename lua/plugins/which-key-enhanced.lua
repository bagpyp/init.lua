-- Enhanced Which-Key configuration with full JetBrains mappings
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      
      wk.setup({
        preset = "modern",
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          mappings = false,
        },
        win = {
          border = "rounded",
          padding = { 2, 2 },
        },
        layout = {
          width = { min = 20, max = 50 },
          spacing = 3,
        },
      })

      -- JetBrains IDE Panels (Space+Number)
      wk.add({
        { "<leader>1", "<cmd>Neotree toggle<cr>", desc = "📁 File Explorer" },
        { "<leader>2", "<cmd>Telescope git_status<cr>", desc = "🔀 Git Status" },
        { "<leader>3", "<cmd>lua require('config.run').toggle()<cr>", desc = "▶️ Run Configs" },
        { "<leader>4", "<cmd>lua require('dapui').toggle()<cr>", desc = "🐛 Debugger" },
        { "<leader>5", "<cmd>DBUI<cr>", desc = "💾 Database" },
        { "<leader>6", "<cmd>lua require('config.docker').toggle()<cr>", desc = "🐳 Docker Services" },
        { "<leader>7", "<cmd>SymbolsOutline<cr>", desc = "🏗️ Structure" },
        { "<leader>8", "<cmd>ToggleTerm<cr>", desc = "💻 Terminal" },
      })

      -- Quick Actions
      wk.add({
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "🔍 Find Files" },
        { "<leader>fp", "<cmd>Telescope commands<cr>", desc = "🎛️ Command Palette" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "🔎 Search in Files" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "📋 Switch Buffer" },
        { "<C-g>", "<cmd>lua require('vim-visual-multi').start()<cr>", desc = "🎯 Multi-Cursor" },
        { "<S-Tab>", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      })

      -- Function Keys
      wk.add({
        { "<F5>", "<cmd>lua require('dap').continue()<cr>", desc = "Debug: Continue" },
        { "<F6>", "<cmd>Move<cr>", desc = "📦 Move File" },
        { "<S-F6>", vim.lsp.buf.rename, desc = "🏷️ Rename Symbol" },
        { "<F10>", "<cmd>lua require('dap').step_over()<cr>", desc = "Debug: Step Over" },
        { "<F11>", "<cmd>lua require('dap').step_into()<cr>", desc = "Debug: Step Into" },
        { "<S-F11>", "<cmd>lua require('dap').step_out()<cr>", desc = "Debug: Step Out" },
      })

      -- Leader mappings
      wk.add({
        -- Files
        { "<leader>f", group = "󰈔 Files" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep Files" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
        { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
        { "<leader>fp", "<cmd>Telescope project<cr>", desc = "Projects" },
        { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
        { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Word Under Cursor" },
        
        -- Tests
        { "<leader>t", group = " Tests" },
        { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run Nearest" },
        { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run File" },
        { "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Test" },
        { "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop" },
        { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach" },
        { "<leader>to", "<cmd>lua require('neotest').output.open()<cr>", desc = "Output" },
        { "<leader>tO", "<cmd>lua require('neotest').output.open({enter = true})<cr>", desc = "Output (Enter)" },
        { "<leader>ti", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
        { "<leader>tw", "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", desc = "Watch" },
        { "<leader>tc", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
        
        -- Debug
        { "<leader>d", group = " Debug" },
        { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
        { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", desc = "Conditional Breakpoint" },
        { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
        { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
        { "<leader>do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
        { "<leader>dO", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
        { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", desc = "Toggle REPL" },
        { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", desc = "Run Last" },
        { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
        { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "Hover Variables" },
        { "<leader>dp", "<cmd>lua require('dap.ui.widgets').preview()<cr>", desc = "Preview" },
        
        -- Git
        { "<leader>g", group = " Git" },
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        { "<leader>gs", "<cmd>Git<cr>", desc = "Status" },
        { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Diff Split" },
        { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
        { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
        { "<leader>gP", "<cmd>Git pull<cr>", desc = "Pull" },
        { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
        { "<leader>gB", "<cmd>Git blame<cr>", desc = "Blame" },
        { "<leader>gl", "<cmd>Git log<cr>", desc = "Log" },
        { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Fetch" },
        { "<leader>gw", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", desc = "Worktrees" },
        { "<leader>gW", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", desc = "Create Worktree" },
        
        -- Hunks (Git)
        { "<leader>h", group = " Hunks" },
        { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
        { "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
        { "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
        { "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage" },
        { "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
        { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
        { "<leader>hb", "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", desc = "Blame Line" },
        { "<leader>hd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
        { "<leader>hD", "<cmd>lua require('gitsigns').diffthis('~')<cr>", desc = "Diff This ~" },
        
        -- LSP
        { "<leader>l", group = " LSP" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>ld", vim.lsp.buf.definition, desc = "Definition" },
        { "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" },
        { "<leader>lf", vim.lsp.buf.format, desc = "Format" },
        { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
        { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
        { "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
        { "<leader>lj", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
        { "<leader>lk", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
        { "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens Action" },
        { "<leader>lq", vim.diagnostic.setloclist, desc = "Quickfix" },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>lR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
        { "<leader>lt", vim.lsp.buf.type_definition, desc = "Type Definition" },
        { "<leader>lw", group = "+Workspace" },
        { "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "Add Folder" },
        { "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Folder" },
        { "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "List Folders" },
        
        -- Code
        { "<leader>c", group = " Code" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
        { "<leader>cf", vim.lsp.buf.format, desc = "Format" },
        { "<leader>cl", vim.lsp.codelens.run, desc = "CodeLens" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>cR", "<cmd>Trouble lsp_references<cr>", desc = "References" },
        { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
        { "<leader>cS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>ct", "<cmd>TodoTelescope<cr>", desc = "Todo Comments" },
        { "<leader>cx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
        { "<leader>cX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
        
        -- Search
        { "<leader>s", group = " Search" },
        { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
        { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
        { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlight Groups" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
        { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
        { "<leader>st", "<cmd>Telescope grep_string<cr>", desc = "Text Under Cursor" },
        
        -- Windows
        { "<leader>w", group = " Windows" },
        { "<leader>ww", "<C-W>p", desc = "Other Window" },
        { "<leader>wd", "<C-W>c", desc = "Delete Window" },
        { "<leader>w-", "<C-W>s", desc = "Split Below" },
        { "<leader>w|", "<C-W>v", desc = "Split Right" },
        { "<leader>w2", "<C-W>v", desc = "Layout Double Columns" },
        { "<leader>wh", "<C-W>h", desc = "Window Left" },
        { "<leader>wj", "<C-W>j", desc = "Window Below" },
        { "<leader>wl", "<C-W>l", desc = "Window Right" },
        { "<leader>wk", "<C-W>k", desc = "Window Up" },
        { "<leader>wH", "<C-W>5<", desc = "Expand Left" },
        { "<leader>wJ", "<C-W>5+", desc = "Expand Below" },
        { "<leader>wL", "<C-W>5>", desc = "Expand Right" },
        { "<leader>wK", "<C-W>5-", desc = "Expand Up" },
        { "<leader>w=", "<C-W>=", desc = "Equal Size" },
        { "<leader>ws", "<C-W>s", desc = "Split Below" },
        { "<leader>wv", "<C-W>v", desc = "Split Right" },
        { "<leader>wx", "<C-W>x", desc = "Swap" },
        
        -- UI/UX
        { "<leader>u", group = "󰏖 UI/UX" },
        { "<leader>uc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
        { "<leader>uh", "<cmd>NoiceAll<cr>", desc = "Noice History" },
        { "<leader>ul", "<cmd>Lazy<cr>", desc = "Lazy" },
        { "<leader>um", "<cmd>Mason<cr>", desc = "Mason" },
        { "<leader>un", "<cmd>Telescope notify<cr>", desc = "Notifications" },
        { "<leader>ut", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      })

      -- Visual mode mappings
      wk.add({
        { "<leader>h", group = " Git Hunks", mode = "v" },
        { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk", mode = "v" },
        { "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk", mode = "v" },
        { "M", "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", desc = "Extract Method", mode = "v" },
      })

      -- Movement mappings
      wk.add({
        { "]", group = "+Next" },
        { "]c", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
        { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
        { "]e", vim.diagnostic.goto_next, desc = "Next Error" },
        { "]w", vim.diagnostic.goto_next, desc = "Next Warning" },
        { "]t", "<cmd>lua require('todo-comments').jump_next()<cr>", desc = "Next Todo" },
        
        { "[", group = "+Previous" },
        { "[c", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous Hunk" },
        { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
        { "[e", vim.diagnostic.goto_prev, desc = "Previous Error" },
        { "[w", vim.diagnostic.goto_prev, desc = "Previous Warning" },
        { "[t", "<cmd>lua require('todo-comments').jump_prev()<cr>", desc = "Previous Todo" },
      })

      -- G mappings
      wk.add({
        { "g", group = "+Goto" },
        { "gd", vim.lsp.buf.definition, desc = "Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
        { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementation" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gt", vim.lsp.buf.type_definition, desc = "Type Definition" },
        { "g?", "<cmd>WhichKey<cr>", desc = "Which Key" },
      })
    end,
  },
}