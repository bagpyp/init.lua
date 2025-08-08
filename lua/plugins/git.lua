return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next Hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous Hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage Hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset Hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame Line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "Diff This ~" })
          map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
        end,
      })
    end,
  },

  -- Git commands
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    ft = { "fugitive" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
      { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
      { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Git Fetch" },
    },
  },

  -- Git diff view
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          },
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            ["<tab>"] = require("diffview.actions").select_next_entry,
            ["<s-tab>"] = require("diffview.actions").select_prev_entry,
            ["gf"] = require("diffview.actions").goto_file,
            ["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
            ["<C-w>gf"] = require("diffview.actions").goto_file_tab,
            ["<leader>e"] = require("diffview.actions").focus_files,
            ["<leader>b"] = require("diffview.actions").toggle_files,
            ["g<C-x>"] = require("diffview.actions").cycle_layout,
            ["[x"] = require("diffview.actions").prev_conflict,
            ["]x"] = require("diffview.actions").next_conflict,
            ["<leader>co"] = require("diffview.actions").conflict_choose("ours"),
            ["<leader>ct"] = require("diffview.actions").conflict_choose("theirs"),
            ["<leader>cb"] = require("diffview.actions").conflict_choose("base"),
            ["<leader>ca"] = require("diffview.actions").conflict_choose("all"),
            ["dx"] = require("diffview.actions").conflict_choose("none"),
          },
          diff1 = {
            ["g?"] = require("diffview.actions").help({ "view", "diff1" }),
          },
          diff2 = {
            ["g?"] = require("diffview.actions").help({ "view", "diff2" }),
          },
          diff3 = {
            { { "2do", "3do" }, require("diffview.actions").diffget("ours") },
            { "4do", require("diffview.actions").diffget("theirs") },
            ["g?"] = require("diffview.actions").help({ "view", "diff3" }),
          },
          diff4 = {
            { { "1do", "4do" }, require("diffview.actions").diffget("base") },
            { { "2do", "3do" }, require("diffview.actions").diffget("ours") },
            { "5do", require("diffview.actions").diffget("theirs") },
            ["g?"] = require("diffview.actions").help({ "view", "diff4" }),
          },
          file_panel = {
            ["j"] = require("diffview.actions").next_entry,
            ["<down>"] = require("diffview.actions").next_entry,
            ["k"] = require("diffview.actions").prev_entry,
            ["<up>"] = require("diffview.actions").prev_entry,
            ["<cr>"] = require("diffview.actions").select_entry,
            ["o"] = require("diffview.actions").select_entry,
            ["<2-LeftMouse>"] = require("diffview.actions").select_entry,
            ["-"] = require("diffview.actions").toggle_stage_entry,
            ["S"] = require("diffview.actions").stage_all,
            ["U"] = require("diffview.actions").unstage_all,
            ["X"] = require("diffview.actions").restore_entry,
            ["L"] = require("diffview.actions").open_commit_log,
            ["<c-b>"] = require("diffview.actions").scroll_view(-0.25),
            ["<c-f>"] = require("diffview.actions").scroll_view(0.25),
            ["<tab>"] = require("diffview.actions").select_next_entry,
            ["<s-tab>"] = require("diffview.actions").select_prev_entry,
            ["gf"] = require("diffview.actions").goto_file,
            ["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
            ["<C-w>gf"] = require("diffview.actions").goto_file_tab,
            ["i"] = require("diffview.actions").listing_style,
            ["f"] = require("diffview.actions").toggle_flatten_dirs,
            ["R"] = require("diffview.actions").refresh_files,
            ["<leader>e"] = require("diffview.actions").focus_files,
            ["<leader>b"] = require("diffview.actions").toggle_files,
            ["g<C-x>"] = require("diffview.actions").cycle_layout,
            ["[x"] = require("diffview.actions").prev_conflict,
            ["]x"] = require("diffview.actions").next_conflict,
            ["g?"] = require("diffview.actions").help("file_panel"),
          },
          file_history_panel = {
            ["g!"] = require("diffview.actions").options,
            ["<C-A-d>"] = require("diffview.actions").open_in_diffview,
            ["y"] = require("diffview.actions").copy_hash,
            ["L"] = require("diffview.actions").open_commit_log,
            ["zR"] = require("diffview.actions").open_all_folds,
            ["zM"] = require("diffview.actions").close_all_folds,
            ["j"] = require("diffview.actions").next_entry,
            ["<down>"] = require("diffview.actions").next_entry,
            ["k"] = require("diffview.actions").prev_entry,
            ["<up>"] = require("diffview.actions").prev_entry,
            ["<cr>"] = require("diffview.actions").select_entry,
            ["o"] = require("diffview.actions").select_entry,
            ["<2-LeftMouse>"] = require("diffview.actions").select_entry,
            ["<c-b>"] = require("diffview.actions").scroll_view(-0.25),
            ["<c-f>"] = require("diffview.actions").scroll_view(0.25),
            ["<tab>"] = require("diffview.actions").select_next_entry,
            ["<s-tab>"] = require("diffview.actions").select_prev_entry,
            ["gf"] = require("diffview.actions").goto_file,
            ["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
            ["<C-w>gf"] = require("diffview.actions").goto_file_tab,
            ["<leader>e"] = require("diffview.actions").focus_files,
            ["<leader>b"] = require("diffview.actions").toggle_files,
            ["g<C-x>"] = require("diffview.actions").cycle_layout,
            ["g?"] = require("diffview.actions").help("file_history_panel"),
          },
          option_panel = {
            ["<tab>"] = require("diffview.actions").select_entry,
            ["q"] = require("diffview.actions").close,
            ["g?"] = require("diffview.actions").help("option_panel"),
          },
          help_panel = {
            ["q"] = require("diffview.actions").close,
          },
        },
      })
    end,
  },

  -- Git worktree
  {
    "ThePrimeagen/git-worktree.nvim",
    config = function()
      require("git-worktree").setup({
        change_directory_command = "cd",
        update_on_change = true,
        update_on_change_command = "e .",
        clearjumps_on_change = true,
        autopush = false,
      })

      require("telescope").load_extension("git_worktree")

      vim.keymap.set("n", "<leader>gw", function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end, { desc = "Git Worktrees" })

      vim.keymap.set("n", "<leader>gW", function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end, { desc = "Create Git Worktree" })
    end,
  },

  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
    },
  },
}