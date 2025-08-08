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
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = false,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        operators = { gc = "Comments" },
        key_labels = {
          ["<space>"] = "SPC",
          ["<cr>"] = "RET",
          ["<tab>"] = "TAB",
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        popup_mappings = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "center",
        },
        ignore_missing = false,
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
        show_help = true,
        show_keys = true,
        triggers = "auto",
        triggers_blacklist = {
          i = { "j", "k" },
          v = { "j", "k" },
        },
      })

      -- JetBrains IDE Panels (Cmd+Number)
      wk.register({
        ["<D-1>"] = { "<cmd>Neotree toggle<cr>", "󰙅 File Explorer" },
        ["<D-2>"] = { "<cmd>Telescope git_status<cr>", " Git Status" },
        ["<D-3>"] = { "<cmd>lua require('config.run').toggle()<cr>", " Run Configs" },
        ["<D-4>"] = { "<cmd>lua require('dapui').toggle()<cr>", " Debugger" },
        ["<D-5>"] = { "<cmd>DBUI<cr>", " Database" },
        ["<D-6>"] = { "<cmd>lua require('config.docker').toggle()<cr>", "🐳 Docker Services" },
        ["<D-7>"] = { "<cmd>SymbolsOutline<cr>", " Structure" },
        ["<D-8>"] = { "<cmd>ToggleTerm<cr>", " Terminal" },
      })

      -- Quick Actions (Cmd+Key)
      wk.register({
        ["<D-p>"] = { "<cmd>Telescope find_files<cr>", "Find Files" },
        ["<D-P>"] = { "<cmd>Telescope commands<cr>", "Command Palette" },
        ["<S-D-f>"] = { "<cmd>Telescope live_grep<cr>", "Search in Files" },
        ["<D-b>"] = { "<cmd>Telescope buffers<cr>", "Switch Buffer" },
        ["<D-g>"] = { "<cmd>lua require('vim-visual-multi').start()<cr>", "Multi-Cursor" },
        ["<S-Tab>"] = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
      })

      -- Function Keys
      wk.register({
        ["<F5>"] = { "<cmd>lua require('dap').continue()<cr>", "Debug: Continue" },
        ["<F6>"] = { "<cmd>Move<cr>", "Move File" },
        ["<S-F6>"] = { vim.lsp.buf.rename, "Rename Symbol" },
        ["<F10>"] = { "<cmd>lua require('dap').step_over()<cr>", "Debug: Step Over" },
        ["<F11>"] = { "<cmd>lua require('dap').step_into()<cr>", "Debug: Step Into" },
        ["<S-F11>"] = { "<cmd>lua require('dap').step_out()<cr>", "Debug: Step Out" },
      })

      -- Leader mappings
      wk.register({
        ["<leader>"] = {
          -- Files
          f = {
            name = "󰈔 Files",
            f = { "<cmd>Telescope find_files<cr>", "Find Files" },
            r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
            g = { "<cmd>Telescope live_grep<cr>", "Grep Files" },
            b = { "<cmd>Telescope buffers<cr>", "Buffers" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
            c = { "<cmd>Telescope commands<cr>", "Commands" },
            m = { "<cmd>Telescope marks<cr>", "Marks" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            t = { "<cmd>Telescope colorscheme<cr>", "Colorschemes" },
            d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
            p = { "<cmd>Telescope project<cr>", "Projects" },
            e = { "<cmd>Telescope file_browser<cr>", "File Browser" },
            w = { "<cmd>Telescope grep_string<cr>", "Word Under Cursor" },
          },
          
          -- Tests
          t = {
            name = " Tests",
            t = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
            f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
            d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Test" },
            s = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
            a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
            o = { "<cmd>lua require('neotest').output.open()<cr>", "Output" },
            O = { "<cmd>lua require('neotest').output.open({enter = true})<cr>", "Output (Enter)" },
            i = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
            w = { "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", "Watch" },
            c = { "<cmd>tabonly<cr>", "Close Other Tabs" },
          },
          
          -- Debug
          d = {
            name = " Debug",
            b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            B = { "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional Breakpoint" },
            c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
            i = { "<cmd>lua require('dap').step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require('dap').step_over()<cr>", "Step Over" },
            O = { "<cmd>lua require('dap').step_out()<cr>", "Step Out" },
            r = { "<cmd>lua require('dap').repl.toggle()<cr>", "Toggle REPL" },
            l = { "<cmd>lua require('dap').run_last()<cr>", "Run Last" },
            u = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
            h = { "<cmd>lua require('dap.ui.widgets').hover()<cr>", "Hover Variables" },
            p = { "<cmd>lua require('dap.ui.widgets').preview()<cr>", "Preview" },
            f = { "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').frames)<cr>", "Frames" },
            s = { "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<cr>", "Scopes" },
          },
          
          -- Git
          g = {
            name = " Git",
            g = { "<cmd>LazyGit<cr>", "LazyGit" },
            s = { "<cmd>Git<cr>", "Status" },
            d = { "<cmd>Gdiffsplit<cr>", "Diff Split" },
            c = { "<cmd>Git commit<cr>", "Commit" },
            p = { "<cmd>Git push<cr>", "Push" },
            P = { "<cmd>Git pull<cr>", "Pull" },
            b = { "<cmd>Telescope git_branches<cr>", "Branches" },
            B = { "<cmd>Git blame<cr>", "Blame" },
            l = { "<cmd>Git log<cr>", "Log" },
            f = { "<cmd>Git fetch<cr>", "Fetch" },
            w = { "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", "Worktrees" },
            W = { "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", "Create Worktree" },
          },
          
          -- Hunks (Git)
          h = {
            name = " Hunks",
            s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
            r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
            S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
            u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage" },
            R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
            p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
            b = { "<cmd>lua require('gitsigns').blame_line{full=true}<cr>", "Blame Line" },
            d = { "<cmd>Gitsigns diffthis<cr>", "Diff This" },
            D = { "<cmd>lua require('gitsigns').diffthis('~')<cr>", "Diff This ~" },
          },
          
          -- LSP
          l = {
            name = " LSP",
            a = { vim.lsp.buf.code_action, "Code Action" },
            d = { vim.lsp.buf.definition, "Definition" },
            D = { vim.lsp.buf.declaration, "Declaration" },
            f = { vim.lsp.buf.format, "Format" },
            h = { vim.lsp.buf.hover, "Hover" },
            i = { "<cmd>LspInfo<cr>", "Info" },
            I = { "<cmd>Mason<cr>", "Mason Info" },
            j = { vim.diagnostic.goto_next, "Next Diagnostic" },
            k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
            l = { vim.lsp.codelens.run, "CodeLens Action" },
            q = { vim.diagnostic.setloclist, "Quickfix" },
            r = { vim.lsp.buf.rename, "Rename" },
            R = { "<cmd>Telescope lsp_references<cr>", "References" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
            S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
            t = { vim.lsp.buf.type_definition, "Type Definition" },
            w = {
              name = "+Workspace",
              a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
              r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
              l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Folders" },
            },
          },
          
          -- Refactor
          r = {
            name = " Refactor",
            e = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract Function" },
            f = { "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", "Extract Function To File" },
            v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract Variable" },
            i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline Variable" },
            I = { "<cmd>lua require('refactoring').refactor('Inline Function')<cr>", "Inline Function" },
            b = { "<cmd>lua require('refactoring').refactor('Extract Block')<cr>", "Extract Block" },
            B = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<cr>", "Extract Block To File" },
            r = { "<cmd>lua require('refactoring').select_refactor()<cr>", "Select Refactor" },
            n = { vim.lsp.buf.rename, "Rename Symbol" },
            m = { "<cmd>Move<cr>", "Move File" },
          },
          
          -- Search
          s = {
            name = " Search",
            a = { "<cmd>Telescope autocommands<cr>", "Auto Commands" },
            b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
            c = { "<cmd>Telescope command_history<cr>", "Command History" },
            C = { "<cmd>Telescope commands<cr>", "Commands" },
            f = { "<cmd>Telescope find_files<cr>", "Find Files" },
            g = { "<cmd>Telescope live_grep<cr>", "Grep" },
            h = { "<cmd>Telescope help_tags<cr>", "Help Pages" },
            H = { "<cmd>Telescope highlights<cr>", "Highlight Groups" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
            m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
            o = { "<cmd>Telescope vim_options<cr>", "Options" },
            r = { "<cmd>Telescope resume<cr>", "Resume" },
            R = { "<cmd>Telescope registers<cr>", "Registers" },
            t = { "<cmd>Telescope grep_string<cr>", "Text Under Cursor" },
          },
          
          -- Code
          c = {
            name = " Code",
            a = { vim.lsp.buf.code_action, "Code Action" },
            d = { vim.diagnostic.open_float, "Line Diagnostics" },
            f = { vim.lsp.buf.format, "Format" },
            l = { vim.lsp.codelens.run, "CodeLens" },
            r = { vim.lsp.buf.rename, "Rename" },
            R = { "<cmd>Trouble lsp_references<cr>", "References" },
            s = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
            S = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
            t = { "<cmd>TodoTelescope<cr>", "Todo Comments" },
            x = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics" },
            X = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics" },
          },
          
          -- Windows
          w = {
            name = " Windows",
            w = { "<C-W>p", "Other Window" },
            d = { "<C-W>c", "Delete Window" },
            ["-"] = { "<C-W>s", "Split Below" },
            ["|"] = { "<C-W>v", "Split Right" },
            ["2"] = { "<C-W>v", "Layout Double Columns" },
            h = { "<C-W>h", "Window Left" },
            j = { "<C-W>j", "Window Below" },
            l = { "<C-W>l", "Window Right" },
            k = { "<C-W>k", "Window Up" },
            H = { "<C-W>5<", "Expand Left" },
            J = { "<C-W>5+", "Expand Below" },
            L = { "<C-W>5>", "Expand Right" },
            K = { "<C-W>5-", "Expand Up" },
            ["="] = { "<C-W>=", "Equal Size" },
            s = { "<C-W>s", "Split Below" },
            v = { "<C-W>v", "Split Right" },
            x = { "<C-W>x", "Swap" },
          },
          
          -- UI/UX
          u = {
            name = "󰏖 UI/UX",
            c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
            h = { "<cmd>NoiceAll<cr>", "Noice History" },
            l = { "<cmd>Lazy<cr>", "Lazy" },
            m = { "<cmd>Mason<cr>", "Mason" },
            n = { "<cmd>Telescope notify<cr>", "Notifications" },
            t = { "<cmd>TodoTelescope<cr>", "Todo" },
          },
        },
      })

      -- Visual mode mappings
      wk.register({
        ["<leader>"] = {
          r = {
            name = " Refactor",
            e = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract Function" },
            f = { "<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>", "Extract Function To File" },
            v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", "Extract Variable" },
            i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<cr>", "Inline Variable" },
          },
          h = {
            name = " Git Hunks",
            s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
            r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
          },
        },
        ["M"] = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Extract Method" },
      }, { mode = "v" })

      -- Movement mappings
      wk.register({
        ["]"] = {
          name = "+Next",
          c = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
          d = { vim.diagnostic.goto_next, "Next Diagnostic" },
          e = { vim.diagnostic.goto_next, "Next Error" },
          w = { vim.diagnostic.goto_next, "Next Warning" },
          f = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Next Failed Test" },
          t = { "<cmd>lua require('todo-comments').jump_next()<cr>", "Next Todo" },
        },
        ["["] = {
          name = "+Previous",
          c = { "<cmd>Gitsigns prev_hunk<cr>", "Previous Hunk" },
          d = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
          e = { vim.diagnostic.goto_prev, "Previous Error" },
          w = { vim.diagnostic.goto_prev, "Previous Warning" },
          f = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Previous Failed Test" },
          t = { "<cmd>lua require('todo-comments').jump_prev()<cr>", "Previous Todo" },
        },
      })

      -- G mappings
      wk.register({
        g = {
          name = "+Goto",
          d = { vim.lsp.buf.definition, "Definition" },
          D = { vim.lsp.buf.declaration, "Declaration" },
          i = { "<cmd>Telescope lsp_implementations<cr>", "Implementation" },
          r = { "<cmd>Telescope lsp_references<cr>", "References" },
          t = { vim.lsp.buf.type_definition, "Type Definition" },
          ["?"] = { "<cmd>WhichKey<cr>", "Which Key" },
        },
      })
    end,
  },
}