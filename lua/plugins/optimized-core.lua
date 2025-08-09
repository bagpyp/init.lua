-- Optimized core configuration combining and deduplicating plugins
return {
  -- File explorer - lazy load on command
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<D-1>", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        use_popups_for_input = false,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
      })
    end,
  },

  -- Terminal - lazy load on command
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<D-8>", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
    },
    config = function()
      require("toggleterm").setup({
        size = 20,
        hide_numbers = true,
        shade_terminals = false, -- Better with transparency
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },

  -- Symbols outline - lazy load on command
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<D-7>", "<cmd>SymbolsOutline<cr>", desc = "Structure" },
    },
    config = function()
      require("symbols-outline").setup({
        highlight_hovered_item = true,
        show_guides = true,
        position = 'right',
        relative_width = true,
        width = 25,
        auto_close = false,
        show_symbol_details = true,
      })
    end,
  },

  -- Database UI - lazy load on command
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    keys = {
      { "<D-5>", "<cmd>DBUI<cr>", desc = "Database" },
    },
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Testing - lazy load on commands and filetypes
  {
    "nvim-neotest/neotest",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "python", "go", "rust" },
    cmd = { "Neotest" },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
      { "<leader>to", function() require("neotest").output.open() end, desc = "Test Output" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-neotest/neotest-jest", ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" } },
      { "nvim-neotest/neotest-python", ft = "python" },
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
        },
      })
    end,
  },

  -- Debugging - lazy load on commands
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut" },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          { "<D-4>", function() require("dapui").toggle() end, desc = "Debugger" },
        },
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      { "theHamsta/nvim-dap-virtual-text", config = true },
      { "mxsdev/nvim-dap-vscode-js", ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" } },
    },
    config = function()
      -- DAP configuration
      local dap = require("dap")
      
      -- JavaScript/TypeScript
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },

  -- Refactoring - lazy load on visual mode and keys
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      { "<leader>re", mode = "v", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function" },
      { "<leader>rv", mode = "v", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable" },
      { "<leader>ri", mode = "n", function() require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable" },
      { "M", mode = "v", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Method" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
  },

  -- Multi-cursor - lazy load on key
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
      { "<C-g>", mode = { "n", "v" }, desc = "Multi-cursor" },
      { "<C-Down>", mode = { "n", "v" }, desc = "Add cursor down" },
      { "<C-Up>", mode = { "n", "v" }, desc = "Add cursor up" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-g>",
        ["Find Subword Under"] = "<C-g>",
        ["Add Cursor Down"] = "<C-Down>",
        ["Add Cursor Up"] = "<C-Up>",
      }
    end,
  },

  -- Expand region - lazy load on key
  {
    "terryma/vim-expand-region",
    keys = {
      { "<M-Up>", "<Plug>(expand_region_expand)", mode = "v", desc = "Expand Selection" },
      { "<M-Down>", "<Plug>(expand_region_shrink)", mode = "v", desc = "Shrink Selection" },
    },
  },

  -- Which-key - load on VeryLazy event
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
          winblend = 0,
        },
      })
    end,
  },
}